FROM node:23.5.0-bookworm@sha256:a569d16e90f2e59da5594793509db37ebfa2d4eb4c5982758fad8f4c79f8ff8f AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.3@sha256:90babf6ca20a03b57f1ecabb39163d95842e6c8e010cebca9eb4b6ffa277b955

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
