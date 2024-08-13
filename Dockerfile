FROM node:22.6.0-bookworm@sha256:27649827e47190ea8c7db5601a980abcaf5b7e2d66a2a186856ddd36c8dde5b5 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.0@sha256:93db6ea665b5485e59f0b35e506456b5055925d43011bdcc459d556332d231a2

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
