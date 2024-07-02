FROM node:22.3.0-bookworm@sha256:118f53d67508d831c0ace77182c6d0f038afeec15eac390cbd3d8c77fbf0b5f3 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.0@sha256:fbb3fa1321fa981aa83728a7b6c666d03e6f025334e806c02ba6d82c2a3f68da

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
