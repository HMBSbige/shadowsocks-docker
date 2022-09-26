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

FROM --platform=$BUILDPLATFORM rust:alpine AS build-rust

ARG TARGETARCH
ARG TARGETOS
ARG SS_RUST_VERSION

RUN case "$TARGETOS" in \
      "linux") ;; \
      *) echo "ERROR: Unsupported OS: ${TARGETOS}"; exit 1 ;; \
    esac && \
    case "$TARGETARCH" in \
    "amd64") \
        RUST_TARGET="x86_64-unknown-linux-musl" \
        MUSL="x86_64-linux-musl" \
    ;; \
    "arm64") \
        RUST_TARGET="aarch64-unknown-linux-musl" \
        MUSL="aarch64-linux-musl" \
    ;; \
    *) \
        echo "ERROR: Unsupported CPU architecture: ${TARGETARCH}" \
        exit 1 \
    ;; \
    esac \
    && apk update \
    && apk upgrade \
    && apk add --no-cache build-base git \
    && git clone --depth 1 -b ${SS_RUST_VERSION} https://github.com/shadowsocks/shadowsocks-rust \
    && cd shadowsocks-rust \
    && wget -qO- "https://github.com/HMBSbige/shadowsocks-docker/releases/download/1.14.2/$MUSL-cross.tgz" | tar -xzC /root/ \
    && PATH="/root/$MUSL-cross/bin:$PATH" \
    && CC=/root/$MUSL-cross/bin/$MUSL-gcc \
    && echo "CC=$CC" \
    && rustup override set nightly \
    && rustup target add "$RUST_TARGET" \
    && RUSTFLAGS="-C linker=$CC" CC=$CC cargo build --target "$RUST_TARGET" --release --features "armv8 neon stream-cipher aead-cipher-extra" \
    && mv target/$RUST_TARGET/release/ss* target/release/

FROM alpine

COPY --from=build-rust /shadowsocks-rust/target/release/ssservice /usr/local/bin/ssservice

COPY --from=build-go /go/src/github.com/shadowsocks/v2ray-plugin/v2ray-plugin /usr/local/bin/v2ray-plugin

HEALTHCHECK CMD ["pidof", "ssservice"]
ENTRYPOINT ["ssservice"]
