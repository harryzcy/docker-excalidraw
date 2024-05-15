FROM node:20.13.1-bookworm@sha256:d6925dc84f8c0d1c1f8df4ea6a9a54e57d430241cb734b1b0c45ed6d26e8e9c0 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.26.0@sha256:192e88a0053c178683ca139b9d9a2afb0ad986d171fae491949fe10970dd9da9

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
