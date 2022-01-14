FROM golang:1.16-alpine AS build-go

RUN apk update \
    && apk upgrade \
    && apk add --no-cache git build-base \
    && mkdir -p /go/src/github.com/shadowsocks \
    && cd /go/src/github.com/shadowsocks \
    && git clone https://github.com/shadowsocks/v2ray-plugin \
    && cd v2ray-plugin \
    && go get -d \
    && go build

RUN ls /go/src/github.com/shadowsocks/v2ray-plugin/v2ray-plugin

FROM rust:alpine AS build-rust

RUN apk update \
    && apk upgrade \
    && apk add --no-cache musl-dev git \
    && git clone https://github.com/shadowsocks/shadowsocks-rust \
    && cd shadowsocks-rust \
    && cargo build --release --features aead-cipher-extra,stream-cipher,local-http,security-iv-printable-prefix

FROM alpine:latest

COPY --from=build-rust /shadowsocks-rust/target/release/ssservice /usr/local/bin/ssservice

COPY --from=build-go /go/src/github.com/shadowsocks/v2ray-plugin/v2ray-plugin /usr/local/bin/v2ray-plugin

HEALTHCHECK CMD ["pidof", "ssservice"]
ENTRYPOINT ["ssservice"]
