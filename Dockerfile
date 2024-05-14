FROM node:20.13.1-bookworm@sha256:f0550f49012688961e8a30a0baa36836495b45fd8c283e9496dc8871ee78ebd1 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.26.0@sha256:9f0d283eccddedf25816104877faf1cb584a8236ec4d7985a4965501d080d84f

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
