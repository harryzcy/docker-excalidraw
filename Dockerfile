FROM node:22.8.0-bookworm@sha256:bd00c03095f7586432805dbf7989be10361d27987f93de904b1fc003949a4794 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.1@sha256:135fbc7ed19c8f644ddf678e68292e678696908451dad7ee2fd4e0cf861f4b6f

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
