FROM node:23.0.0-bookworm@sha256:ee15fc1b7ee0e8352e37a58669c465ad2b94c864d209cc18619d4511808407c0 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.2@sha256:a6b75a320a9a95bcaed28484349557d1ec7426041be35a62386dfa6609225ad3

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
