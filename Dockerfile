FROM node:22.4.0-bookworm@sha256:6507334120736446cbcf13486ea21bf697c4cecbb7d43f59fba8d49f337ea09e AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.0@sha256:b31263533dda53e7d9762dce38da81452ec0a959a1f714859466bc4c5e9cbbae

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
