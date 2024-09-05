FROM node:22.8.0-bookworm@sha256:99513efaf4fa3fa7b0f35b3bcc194e6da2fe1c0f71107d10b6b106ddace73cfb AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.1@sha256:0e4fe3ef42d60ff3586428b7892f9e5d0156206117c701e4e2282f1b29e129b5

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
