FROM node:22.0.0-bookworm@sha256:65d1bbc530efc7f4814ddcf6a37e730ee0ef2f73a21d9641cbab5d479c4d96e5 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.26.0@sha256:ba9587717b056e1993b051f71cea30ddd5caf09ae2087b1eeb11329f52468e49

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
