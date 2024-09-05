FROM node:22.8.0-bookworm@sha256:7cbc7e41c78f055826a9e2498ecac951fdbc1b0cc3b5d70e7ee5d57189a9de41 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.1@sha256:81c3851a6f8cfd0ef8db76764352809e42db5cd44f97804cc1d4846afa845816

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
