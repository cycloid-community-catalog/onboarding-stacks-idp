import { createServer, type IncomingMessage, type IncomingHttpHeaders, type ServerResponse } from "node:http";
import { request as httpRequest } from "node:http";
import { request as httpsRequest } from "node:https";
import { brotliDecompressSync, gunzipSync, inflateSync } from "node:zlib";

const PLUGIN_VERSION = "2.0.6";

const port = Number(process.env.PORT);
if (!Number.isFinite(port) || port <= 0) {
  console.error("FATAL: PORT environment variable is not set or is invalid");
  process.exit(1);
}

const ARGOCD_USERNAME = process.env.ARGOCD_USERNAME?.trim() || "admin";
const ARGOCD_PASSWORD = process.env.ARGOCD_PASSWORD ?? "cycloid";
const ARGOCD_ZONE = process.env.ARGOCD_ZONE?.trim() || "demo.cycloid.io";
const ARGOCD_ENTRY_PATH =
  process.env.ARGOCD_ENTRY_PATH?.trim() || "/applications/argocd/app-of-apps";
const SESSION_TTL_MS = 12 * 60 * 60 * 1000;

function parseBoolEnv(value: string | undefined, defaultValue: boolean): boolean {
  if (value === undefined || value.trim() === "") return defaultValue;
  const v = value.trim().toLowerCase();
  if (["1", "true", "yes", "on"].includes(v)) return true;
  if (["0", "false", "no", "off"].includes(v)) return false;
  return defaultValue;
}

const ARGOCD_INSECURE_TLS = parseBoolEnv(
  process.env.ARGOCD_INSECURE_TLS ?? process.env.argocd_insecure_tls,
  true,
);

type ComponentContext = {
  org: string;
  project: string;
  env: string;
  component: string;
};

type ArgoConn = { host: string; baseUrl: string };
type SessionEntry = { token: string; updatedAt: number };

const sessions = new Map<string, SessionEntry>();

console.log(
  `[INFO] plugin v${PLUGIN_VERSION}: user='${ARGOCD_USERNAME}' zone='${ARGOCD_ZONE}' ` +
    `entry='${ARGOCD_ENTRY_PATH}' insecure_tls=${ARGOCD_INSECURE_TLS}`,
);

function argocdConn(org: string): ArgoConn {
  const host = `argocd.${org}.${ARGOCD_ZONE}`;
  return { host, baseUrl: `https://${host}` };
}

function parseRequestUrl(req: IncomingMessage): URL {
  const host = req.headers.host?.trim() || "localhost";
  const base = host.includes("://") ? host : `http://${host}`;
  try {
    return new URL(req.url ?? "/", base);
  } catch {
    return new URL("/", base);
  }
}

function normalizeSlashes(pathname: string): string {
  const collapsed = pathname.replace(/\/+/g, "/");
  if (collapsed.length > 1 && collapsed.endsWith("/")) return collapsed.slice(0, -1);
  return collapsed || "/";
}

function normalizePluginPath(pathname: string): string {
  const path = normalizeSlashes(pathname || "/");
  const iframeIdx = path.indexOf("/iframe");
  if (iframeIdx >= 0) {
    const rest = path.slice(iframeIdx + "/iframe".length);
    if (!rest || rest === "/") return "/";
    return rest.startsWith("/") ? rest : `/${rest}`;
  }
  const widgetMatch = /\/plugin_widgets\/\d+\/[^/]+/.exec(path);
  if (widgetMatch) {
    const rest = path.slice(widgetMatch.index + widgetMatch[0].length);
    if (!rest || rest === "/") return "/";
    return rest.startsWith("/") ? rest : `/${rest}`;
  }
  return path;
}

function resolvePathname(url: URL, rawPathname: string): string {
  const proxyPath = url.searchParams.get("path")?.trim();
  if (proxyPath) {
    const normalized = proxyPath.startsWith("/") ? proxyPath : `/${proxyPath}`;
    return normalizePluginPath(normalized);
  }
  return normalizePluginPath(rawPathname);
}

const COMPONENT_PATH =
  /\/organizations\/([^/]+)\/projects\/([^/]+)\/environments\/([^/]+)\/components\/([^/?#]+)/;

function contextFromPathValue(value: string): ComponentContext | null {
  const match = COMPONENT_PATH.exec(value);
  if (!match) return null;
  return {
    org: decodeURIComponent(match[1]!),
    project: decodeURIComponent(match[2]!),
    env: decodeURIComponent(match[3]!),
    component: decodeURIComponent(match[4]!),
  };
}

function contextFromQuery(url: URL): ComponentContext | null {
  const org = url.searchParams.get("org")?.trim();
  const project = url.searchParams.get("project")?.trim() ?? "";
  const env = url.searchParams.get("env")?.trim();
  const component = url.searchParams.get("component")?.trim();
  if (!org || !env || !component) return null;
  return { org, project, env, component };
}

function contextFromReferer(req: IncomingMessage): ComponentContext | null {
  const referer = req.headers.referer ?? req.headers.referrer;
  if (typeof referer !== "string" || !referer) return null;
  return contextFromPathValue(referer);
}

function contextFromForwardedHeaders(req: IncomingMessage): ComponentContext | null {
  const headerNames = [
    "x-forwarded-uri",
    "x-original-url",
    "x-forwarded-path",
    "x-cycloid-plugin-uri",
    "x-request-uri",
    "x-rewrite-url",
  ] as const;

  for (const name of headerNames) {
    const value = req.headers[name];
    if (typeof value !== "string") continue;
    const ctx = contextFromPathValue(value);
    if (ctx) return ctx;
  }

  for (const value of Object.values(req.headers)) {
    if (typeof value !== "string" || !value.includes("/organizations/")) continue;
    const ctx = contextFromPathValue(value);
    if (ctx) return ctx;
  }

  return null;
}

function resolveContext(req: IncomingMessage, url: URL): ComponentContext | null {
  return (
    contextFromQuery(url) ??
    contextFromPathValue(url.pathname) ??
    (req.url ? contextFromPathValue(req.url) : null) ??
    contextFromForwardedHeaders(req) ??
    contextFromReferer(req)
  );
}

function iframeBaseFromPathValue(value: string): string {
  const match = /(\/organizations\/[^\s?#]*\/iframe)/.exec(value);
  if (match) return match[1]!;
  try {
    const path = new URL(value, "http://local").pathname;
    const base = iframeBaseFromPathname(path);
    if (base) return base;
  } catch {
    /* ignore */
  }
  return iframeBaseFromPathname(value);
}

function iframeBaseFromPathname(pathname: string): string {
  const iframeIdx = pathname.indexOf("/iframe");
  if (iframeIdx < 0) return "";
  return pathname.slice(0, iframeIdx + "/iframe".length);
}

function getPublicBase(req: IncomingMessage, url: URL): string {
  const headerNames = [
    "x-forwarded-uri",
    "x-original-url",
    "x-forwarded-path",
    "x-cycloid-plugin-uri",
    "x-request-uri",
    "x-rewrite-url",
  ] as const;

  for (const name of headerNames) {
    const value = req.headers[name];
    if (typeof value !== "string") continue;
    const base = iframeBaseFromPathValue(value);
    if (base) return base;
  }

  const referer = req.headers.referer ?? req.headers.referrer;
  if (typeof referer === "string" && referer) {
    const base = iframeBaseFromPathValue(referer);
    if (base) return base;
  }

  return iframeBaseFromPathname(url.pathname);
}

function send(
  res: ServerResponse,
  status: number,
  body: string | object,
  contentType = "application/json",
): void {
  const payload = typeof body === "string" ? body : JSON.stringify(body);
  res.writeHead(status, { "content-type": contentType });
  res.end(payload);
}

function escapeHtml(s: string): string {
  return s
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function isGzipBody(body: Buffer): boolean {
  return body.length >= 2 && body[0] === 0x1f && body[1] === 0x8b;
}

function decodeUpstreamBody(body: Buffer, contentEncoding: string | undefined): Buffer {
  const enc = (contentEncoding ?? "").toLowerCase();
  try {
    if (enc.includes("gzip") || (!enc && isGzipBody(body))) return gunzipSync(body);
    if (enc.includes("deflate")) return inflateSync(body);
    if (enc.includes("br")) return brotliDecompressSync(body);
  } catch {
    /* return raw body if decoding fails */
  }
  return body;
}

function prepareUpstreamHeaders(
  incoming: Record<string, string>,
  extras: Record<string, string> = {},
): Record<string, string> {
  const headers: Record<string, string> = {};
  for (const [key, value] of Object.entries(incoming)) {
    const lower = key.toLowerCase();
    if (lower === "host" || lower === "accept-encoding") continue;
    headers[lower] = value;
  }
  headers["accept-encoding"] = "identity";
  Object.assign(headers, extras);
  return headers;
}

type ReqInit = {
  method: "GET" | "POST" | "PUT" | "PATCH" | "DELETE";
  headers?: Record<string, string>;
  body?: string;
};

function upstreamRequest(
  target: URL,
  init: ReqInit,
): Promise<{ status: number; headers: IncomingHttpHeaders; body: Buffer }> {
  return new Promise((resolve, reject) => {
    const isHttps = target.protocol === "https:";
    const request = isHttps ? httpsRequest : httpRequest;
    const headers: Record<string, string> = { ...(init.headers ?? {}) };
    if (init.body !== undefined) {
      headers["content-type"] ??= "application/json";
      headers["content-length"] = String(Buffer.byteLength(init.body));
    }
    headers.host = target.hostname;
    headers["accept-encoding"] = "identity";

    const req = request(
      {
        hostname: target.hostname,
        port: target.port || (isHttps ? 443 : 80),
        path: `${target.pathname}${target.search}`,
        method: init.method,
        headers,
        servername: isHttps ? target.hostname : undefined,
        rejectUnauthorized: !ARGOCD_INSECURE_TLS,
      },
      (res) => {
        const chunks: Buffer[] = [];
        res.on("data", (chunk: Buffer) => chunks.push(chunk));
        res.on("end", () => {
          resolve({
            status: res.statusCode ?? 0,
            headers: res.headers,
            body: decodeUpstreamBody(
              Buffer.concat(chunks),
              String(res.headers["content-encoding"] ?? ""),
            ),
          });
        });
      },
    );
    req.on("error", reject);
    if (init.body !== undefined) req.write(init.body);
    req.end();
  });
}

async function argocdLogin(conn: ArgoConn): Promise<string> {
  const res = await upstreamRequest(new URL("/api/v1/session", conn.baseUrl), {
    method: "POST",
    body: JSON.stringify({ username: ARGOCD_USERNAME, password: ARGOCD_PASSWORD }),
  });
  if (res.status < 200 || res.status >= 300) {
    throw new Error(`ArgoCD login HTTP ${res.status}: ${res.body.toString("utf8").slice(0, 200)}`);
  }
  const parsed = JSON.parse(res.body.toString("utf8")) as { token?: string };
  if (!parsed.token) throw new Error("ArgoCD login: no token in response");
  return parsed.token;
}

async function getSessionToken(org: string): Promise<string> {
  const cached = sessions.get(org);
  if (cached && Date.now() - cached.updatedAt < SESSION_TTL_MS) return cached.token;
  const token = await argocdLogin(argocdConn(org));
  sessions.set(org, { token, updatedAt: Date.now() });
  return token;
}

const STRIPPED_RESPONSE_HEADERS = new Set([
  "x-frame-options",
  "content-security-policy",
  "content-security-policy-report-only",
  "host",
  "content-length",
  "content-encoding",
]);

const HOP_BY_HOP_HEADERS = new Set([
  "connection",
  "keep-alive",
  "proxy-authenticate",
  "proxy-authorization",
  "te",
  "trailers",
  "transfer-encoding",
  "upgrade",
]);

const PROXY_QUERY_PARAMS = new Set(["org", "project", "env", "component", "path"]);

function stripPluginQuery(search: string): string {
  if (!search) return "";
  const params = new URLSearchParams(search.startsWith("?") ? search.slice(1) : search);
  for (const key of PROXY_QUERY_PARAMS) params.delete(key);
  const qs = params.toString();
  return qs ? `?${qs}` : "";
}

function rewriteLocation(location: string, publicBase: string): string {
  if (!publicBase) return location;
  const trimmed = location.trim();
  if (!trimmed) return publicBase;

  let pathAndQuery = trimmed;
  let hash = "";
  const hashIdx = pathAndQuery.indexOf("#");
  if (hashIdx >= 0) {
    hash = pathAndQuery.slice(hashIdx);
    pathAndQuery = pathAndQuery.slice(0, hashIdx);
  }

  if (/^https?:\/\//i.test(pathAndQuery)) {
    try {
      const parsed = new URL(pathAndQuery);
      pathAndQuery = `${parsed.pathname}${parsed.search}`;
    } catch {
      return location;
    }
  }

  if (pathAndQuery.startsWith(publicBase)) return `${pathAndQuery}${hash}`;
  if (pathAndQuery.startsWith("?")) return `${publicBase}${pathAndQuery}${hash}`;
  if (pathAndQuery.startsWith("/")) return `${publicBase}${pathAndQuery}${hash}`;
  return `${publicBase}/${pathAndQuery}${hash}`;
}

function rewriteArgocdAbsoluteUrls(html: string, conn: ArgoConn, publicBase: string): string {
  if (!publicBase || !html.includes(conn.host)) return html;
  const escaped = conn.host.replace(/\./g, "\\.");
  return html.replace(new RegExp(`https?:\\/\\/${escaped}`, "gi"), publicBase);
}

function rewriteRootRelativeUrls(html: string, publicBase: string): string {
  if (!publicBase || !html.includes("/")) return html;
  return html.replace(/(\s(?:action|href|src)\s*=\s*["'])\/(?!\/)/gi, `$1${publicBase}/`);
}

const IFRAME_CLIENT_SCRIPT = `<script>(function(){
function iframePrefix(){var p=location.pathname;var i=p.indexOf("/iframe");if(i<0)return"";return p.slice(0,i+"/iframe".length)}
var base=iframePrefix();
if(base&&!document.querySelector("base")){
  var el=document.createElement("base");
  el.href=location.origin+base+"/";
  (document.head||document.documentElement).prepend(el);
}
function fixUrl(u){
  if(!u||/^https?:\\/\\//i.test(u)||u.indexOf("//")===0)return u;
  if(!base)return u;
  if(u.charAt(0)==="/")return location.origin+base+u;
  return u;
}
function patch(){
  document.querySelectorAll("a[href^='/']").forEach(function(el){el.setAttribute("href",fixUrl(el.getAttribute("href")))});
  document.querySelectorAll('form[action^="/"]').forEach(function(el){el.setAttribute("action",fixUrl(el.getAttribute("action")))});
}
patch();
new MutationObserver(patch).observe(document.documentElement,{childList:true,subtree:true});
var of=window.fetch;
window.fetch=function(input,init){
  try{
    var url=typeof input==="string"?input:(input&&input.url);
    if(url&&url.charAt(0)==="/"&&base){
      var fixed=location.origin+base+url;
      return of(typeof input==="string"?fixed:new Request(fixed,init),init);
    }
  }catch(e){}
  return of.apply(this,arguments);
};
})();</script>`;

function injectHtmlFixes(html: string, publicBase: string, conn: ArgoConn): string {
  if (!html.includes("<")) return html;
  let out = rewriteArgocdAbsoluteUrls(html, conn, publicBase);
  out = rewriteRootRelativeUrls(out, publicBase);
  if (publicBase && !/<base[\s>]/i.test(out)) {
    const href = `${publicBase}/`.replace(/"/g, "&quot;");
    const tag = `<base href="${href}">`;
    out = /<head[\s>]/i.test(out)
      ? out.replace(/<head(\s[^>]*)?>/i, (m) => `${m}${tag}`)
      : `${tag}${out}`;
  }
  const script = IFRAME_CLIENT_SCRIPT;
  return /<head[\s>]/i.test(out)
    ? out.replace(/<head(\s[^>]*)?>/i, (m) => `${m}${script}`)
    : `${script}${out}`;
}

function filterProxyHeaders(
  headers: IncomingHttpHeaders,
  publicBase: string,
): Record<string, string | string[]> {
  const out: Record<string, string | string[]> = {};
  for (const [key, value] of Object.entries(headers)) {
    if (value === undefined) continue;
    const lower = key.toLowerCase();
    if (HOP_BY_HOP_HEADERS.has(lower) || STRIPPED_RESPONSE_HEADERS.has(lower)) continue;
    if (lower === "location" && typeof value === "string") {
      out[key] = rewriteLocation(value, publicBase);
      continue;
    }
    out[key] = value;
  }
  return out;
}

async function readRequestBody(req: IncomingMessage): Promise<Buffer | undefined> {
  const method = req.method ?? "GET";
  if (method === "GET" || method === "HEAD") return undefined;
  const chunks: Buffer[] = [];
  for await (const chunk of req) chunks.push(chunk as Buffer);
  return Buffer.concat(chunks);
}

function renderError(message: string): string {
  return `<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8" /><title>Argo CD</title></head>
<body style="font-family:system-ui,sans-serif;padding:1.5rem">
  <p style="color:#b71c1c;background:#ffebee;padding:1rem;border-radius:8px">${escapeHtml(message)}</p>
</body>
</html>`;
}

async function proxyArgoCd(
  req: IncomingMessage,
  res: ServerResponse,
  pathname: string,
  search: string,
  ctx: ComponentContext,
  publicBase: string,
  body: Buffer | undefined,
): Promise<void> {
  const conn = argocdConn(ctx.org);
  let token: string;
  try {
    token = await getSessionToken(ctx.org);
  } catch (err) {
    res.writeHead(502, { "content-type": "text/html; charset=utf-8" });
    res.end(renderError(`Cannot log in to Argo CD at ${conn.host}: ${(err as Error).message}`));
    return;
  }

  const upstreamPath =
    pathname === "/" || pathname === "/index.html" ? ARGOCD_ENTRY_PATH : pathname;

  if (pathname === "/" || pathname === "/index.html") {
    console.log(
      `[INFO] component tab: org=${ctx.org} env=${ctx.env} component=${ctx.component} → ${upstreamPath}`,
    );
  }

  const target = new URL(`${upstreamPath}${stripPluginQuery(search)}`, conn.baseUrl);
  const method = (req.method ?? "GET").toUpperCase();
  const incomingHeaders: Record<string, string> = {};
  for (const [key, value] of Object.entries(req.headers)) {
    if (value === undefined) continue;
    incomingHeaders[key] = Array.isArray(value) ? value.join(", ") : value;
  }
  const headers = prepareUpstreamHeaders(incomingHeaders, {
    authorization: `Bearer ${token}`,
    cookie: `argocd.token=${token}`,
    ...(body !== undefined ? { "content-length": String(body.length) } : {}),
  });

  const upstream = (target.protocol === "https:" ? httpsRequest : httpRequest)(
    {
      hostname: target.hostname,
      port: target.port || (target.protocol === "https:" ? 443 : 80),
      path: `${target.pathname}${target.search}`,
      method,
      headers,
      servername: target.protocol === "https:" ? target.hostname : undefined,
      rejectUnauthorized: !ARGOCD_INSECURE_TLS,
    },
    (upstreamRes) => {
      if (upstreamRes.statusCode === 401) sessions.delete(ctx.org);

      const chunks: Buffer[] = [];
      upstreamRes.on("data", (chunk: Buffer) => chunks.push(chunk));
      upstreamRes.on("end", () => {
        const raw = decodeUpstreamBody(
          Buffer.concat(chunks),
          String(upstreamRes.headers["content-encoding"] ?? ""),
        );
        const contentType = String(upstreamRes.headers["content-type"] ?? "");
        const responseHeaders = filterProxyHeaders(upstreamRes.headers, publicBase);

        if (contentType.includes("text/html")) {
          const html = Buffer.from(injectHtmlFixes(raw.toString("utf8"), publicBase, conn), "utf8");
          responseHeaders["content-length"] = String(html.length);
          res.writeHead(upstreamRes.statusCode ?? 502, responseHeaders);
          res.end(html);
          return;
        }

        responseHeaders["content-length"] = String(raw.length);
        res.writeHead(upstreamRes.statusCode ?? 502, responseHeaders);
        res.end(raw);
      });
    },
  );

  upstream.on("error", (err) => {
    res.writeHead(502, { "content-type": "text/plain; charset=utf-8" });
    res.end(`Argo CD proxy error: ${(err as Error).message}`);
  });

  if (body !== undefined) upstream.write(body);
  upstream.end();
}

const server = createServer(async (req, res) => {
  const start = Date.now();
  const method = req.method ?? "GET";
  const url = parseRequestUrl(req);
  const pathname = resolvePathname(url, url.pathname);
  const publicBase = getPublicBase(req, url);
  const ctx = resolveContext(req, url);

  res.on("finish", () => {
    const ms = Date.now() - start;
    const level = res.statusCode >= 500 ? "ERROR" : res.statusCode >= 400 ? "WARN" : "INFO";
    console.log(`[${level}] ${method} ${pathname} → ${res.statusCode} (${ms}ms)`);
  });

  if (method === "GET" && pathname === "/_cy/ping") return send(res, 200, { ok: true });
  if (method === "POST" && pathname === "/_cy/events") return send(res, 200, { ok: true });
  if (method === "DELETE" && pathname === "/_cy/plugin") {
    sessions.clear();
    return send(res, 200, { ok: true });
  }
  if (method === "POST" && pathname === "/_cy/resync") return send(res, 200, { started: false });

  if (method === "GET" && pathname === "/_cy/context-debug") {
    return send(res, 200, {
      context: ctx,
      url: req.url ?? null,
      pathname,
      referer: req.headers.referer ?? req.headers.referrer ?? null,
      forwardedUri: req.headers["x-forwarded-uri"] ?? null,
      publicBase: publicBase || null,
    });
  }

  if (!ctx) {
    console.warn(
      `[WARN] missing component context: method=${method} url=${req.url ?? "-"} ` +
        `referer=${String(req.headers.referer ?? req.headers.referrer ?? "-")}`,
    );
    if (method === "GET" && (pathname === "/" || pathname === "/index.html")) {
      return send(
        res,
        400,
        renderError(
          "Missing Cycloid component context. Open this tab from a component page (org, env, component).",
        ),
        "text/html; charset=utf-8",
      );
    }
    return send(res, 400, { error: "Missing component context (org, env, component)" });
  }

  const body = await readRequestBody(req);
  return proxyArgoCd(req, res, pathname, url.search, ctx, publicBase, body);
});

server.listen(port, "0.0.0.0", () => {
  console.log(`[INFO] listening on http://0.0.0.0:${port}`);
});
