ARG GO_VERSION

FROM golang:${GO_VERSION}-alpine AS build-go

ARG V2RAY_PLUGIN_VERSION

RUN apk update \
    && apk upgrade \
    && apk add --no-cache git build-base \
    && mkdir -p /go/src/github.com/shadowsocks \
    && cd /go/src/github.com/shadowsocks \
    && git clone --depth 1 -b ${V2RAY_PLUGIN_VERSION} https://github.com/shadowsocks/v2ray-plugin \
    && cd v2ray-plugin \
    && go get -d \
    && go build

RUN ls /go/src/github.com/shadowsocks/v2ray-plugin/v2ray-plugin

FROM rust:alpine AS build-rust

ARG SS_RUST_VERSION

RUN apk update \
    && apk upgrade \
    && apk add --no-cache musl-dev git \
    && git clone --depth 1 -b ${SS_RUST_VERSION} https://github.com/shadowsocks/shadowsocks-rust \
    && cd shadowsocks-rust \
    && cargo build --release --features aead-cipher-extra,stream-cipher,local-http

FROM alpine:latest

COPY --from=build-rust /shadowsocks-rust/target/release/ssservice /usr/local/bin/ssservice

COPY --from=build-go /go/src/github.com/shadowsocks/v2ray-plugin/v2ray-plugin /usr/local/bin/v2ray-plugin

HEALTHCHECK CMD ["pidof", "ssservice"]
ENTRYPOINT ["ssservice"]
