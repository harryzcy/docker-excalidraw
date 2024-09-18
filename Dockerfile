FROM node:22.9.0-bookworm@sha256:cbe2d5f94110cea9817dd8c5809d05df49b4bd1aac5203f3594d88665ad37988 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.1@sha256:135fbc7ed19c8f644ddf678e68292e678696908451dad7ee2fd4e0cf861f4b6f

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
