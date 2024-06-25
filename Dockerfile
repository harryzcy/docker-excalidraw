FROM node:20.15.0-bookworm@sha256:fb4395cc0700af7f1fcfd7551ed0dca6625df5293b6ba2d57cc12422a4f52e0d AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.0@sha256:9c367186df9a6b18c6735357b8eb7f407347e84aea09beb184961cb83543d46e

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
