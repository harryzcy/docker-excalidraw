FROM node:22.5.1-bookworm@sha256:41a78fa18185639ae24f9148980ebf9d69c0a1463848f691b7b1265e86778f1a AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.0@sha256:97b83c73d3165f2deb95e02459a6e905f092260cd991f4c4eae2f192ddb99cbe

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
