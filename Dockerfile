FROM node:20.12.2-bookworm@sha256:1de802fdf24ea1b1b5dddb5bbd17049708e61226c9753879360d056298fd5c66 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.26.0@sha256:3f28ecedbd787b3ff0a6d56cd4a1b13901acda532c717e3b7351fcc786973d79

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
