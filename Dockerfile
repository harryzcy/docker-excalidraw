FROM node:22.8.0-bookworm@sha256:8ec02324cb37718197de92e51677781be9f1345c709f31a1f44440c6036d24a2 AS build

ARG VERSION=v0.17.3
RUN git clone --depth 1 --branch ${VERSION} https://github.com/excalidraw/excalidraw.git

WORKDIR /excalidraw

RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27.1@sha256:81c3851a6f8cfd0ef8db76764352809e42db5cd44f97804cc1d4846afa845816

COPY --from=build /excalidraw/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
