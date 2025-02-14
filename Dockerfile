FROM node:23.8.0-bookworm@sha256:5fe170d5d0f8fd66806405595ee9d27d20b2d74cde58be3f582bb279888f4c9b AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.4@sha256:91734281c0ebfc6f1aea979cffeed5079cfe786228a71cc6f1f46a228cde6e34

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
