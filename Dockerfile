FROM node:23.0.0-bookworm@sha256:ee15fc1b7ee0e8352e37a58669c465ad2b94c864d209cc18619d4511808407c0 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.2@sha256:ff466795a4535e1d47cf2b901ce15b0ad2ba7f6e0140f12f7d62cb1c9160067a

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
