# Cycloid plugin — ArgoCD (component tab)

Cycloid plugin that embeds the **Argo CD** application view for the current component in an **iframe** component tab — same pattern as [plugin-adminer](https://github.com/cycloid-community-catalog/onboarding-stacks-cmp/tree/master/plugin-adminer) and [plugin-postgresql-users](https://github.com/cycloid-community-catalog/onboarding-stacks-cmp/tree/master/plugin-postgresql-users).

## Widget

| Tab | Type | Placement |
|-----|------|-----------|
| **ArgoCD** | `iframe` | `component` (`tab_name: ArgoCD`) |

The plugin resolves the Cycloid component context (`org`, `env`, `component`) from the iframe request, logs into `https://argocd.<org>.demo.cycloid.io`, and proxies the Argo CD UI starting at **`/applications/argocd/app-of-apps`**.

## Install

Only Argo CD credentials are required at install time (defaults match the demo stacks):

```bash
cy plugin install argocd \
  --config argocd_username=admin \
  --config argocd_password=cycloid
```

| `key` | Env var | Default | Description |
|-------|---------|---------|-------------|
| `argocd_username` | `ARGOCD_USERNAME` | `admin` | Argo CD local account |
| `argocd_password` | `ARGOCD_PASSWORD` | `cycloid` | Argo CD password |

Optional runtime override:

| Env var | Default | Description |
|---------|---------|-------------|
| `ARGOCD_ZONE` | `demo.cycloid.io` | DNS zone suffix (`argocd.<org>.<zone>`) |
| `ARGOCD_INSECURE_TLS` | `true` | Accept self-signed Argo CD ingress certificates (demo stacks) |
| `ARGOCD_ENTRY_PATH` | `/applications/argocd/app-of-apps` | Argo CD UI path opened in the component tab |

## Enable on a component

1. **Install** at org level with credentials (or accept defaults).
2. On the component: **Plugins** → enable this plugin.
3. Open the **ArgoCD** tab on that component.

## Files

| File | Purpose |
|------|---------|
| `manifest.yaml` | Install form (username / password) |
| `widgets.yaml` | `iframe` on `placement.type: component` |
| `server.ts` | Node HTTP server: login + Argo CD UI reverse proxy |
| `Dockerfile` | `node:22-bookworm-slim`, no build step |

## Build and publish

```bash
cd plugin-argocd
chmod +x scripts/build-and-push.sh
IMAGE=<registry>/cycloid-plugin-argocd ./scripts/build-and-push.sh
```

The image tag is read from `plugin/package.json` (semver). Example:

```bash
IMAGE=cycloid-docker-registry:5000/cycloid-plugin-argocd ./scripts/build-and-push.sh
```

## Troubleshooting

**Missing Cycloid component context**

The plugin resolves `org`, `project`, `env`, and `component` from (in order): the
widget query string, the request path, Cycloid proxy headers (`x-forwarded-uri`, …),
and the `Referer` header.

Check what the container received:

```bash
cy plugin logs cycloid-plugin-argocd | grep -E 'missing component|component tab'
```

Or open `/_cy/context-debug` on the widget iframe URL for a JSON snapshot of
parsed context and proxy headers.

Rebuild and upgrade to **2.0.6** after entry path changes.

## Local smoke test

```bash
cd plugin
PORT=8080 ARGOCD_USERNAME=admin ARGOCD_PASSWORD=cycloid \
  node --experimental-strip-types server.ts
```

```bash
curl -fsS http://localhost:8080/_cy/ping
open 'http://localhost:8080/?org=myorg&project=demo&env=dev&component=pr1'
```
