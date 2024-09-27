FROM node:22.9.0-bookworm@sha256:e4ec3891c64348aa8358e36394fc61afae30af4e4cc00f38f84d65f72b758c59 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.1@sha256:d49075921353f9cc6c377ba60fd0c915fe8fe7a96813f64b82bca5f1e9ab76e9

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
