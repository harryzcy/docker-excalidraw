FROM node:22.6.0-bookworm@sha256:72314283e7a651d65a367f4e72fde18ec431a73ccfc87977f81be5dfc99c1c94 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.0@sha256:6af79ae5de407283dcea8b00d5c37ace95441fd58a8b1d2aa1ed93f5511bb18c

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
