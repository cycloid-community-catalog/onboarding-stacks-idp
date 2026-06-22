# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim

WORKDIR /plugin

COPY manifest.yaml widgets.yaml package.json server.ts ./

RUN test -f /plugin/manifest.yaml && test -f /plugin/widgets.yaml \
    || (echo "ERROR: /plugin/manifest.yaml and /plugin/widgets.yaml are required" && exit 1)

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["node", "--experimental-strip-types", "/plugin/server.ts"]
