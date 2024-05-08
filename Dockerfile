FROM node:20.13.0-bookworm@sha256:b6e7fef05c7609784c320e5c746aaf8d49221ec0eb3c1242fb673099511b0583 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.26.0@sha256:9f0d283eccddedf25816104877faf1cb584a8236ec4d7985a4965501d080d84f

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
