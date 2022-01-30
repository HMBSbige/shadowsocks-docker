# shadowsocks-docker
[![Docker](https://github.com/HMBSbige/shadowsocks-docker/actions/workflows/build-latest.yml/badge.svg)](https://github.com/HMBSbige/shadowsocks-docker/actions/workflows/build-latest.yml)
[![Docker](https://github.com/HMBSbige/shadowsocks-docker/actions/workflows/build-release.yml/badge.svg)](https://github.com/HMBSbige/shadowsocks-docker/actions/workflows/build-release.yml)
[![Docker](https://img.shields.io/badge/shadowsocks-blue?label=Docker&logo=docker)](https://github.com/users/HMBSbige/packages/container/package/shadowsocks)

[![shadowsocks-rust](https://img.shields.io/badge/shadowsocks--rust-dea584?label=GitHub&logo=github)](https://github.com/shadowsocks/shadowsocks-rust)
[![v2ray-plugin](https://img.shields.io/badge/v2ray--plugin-00add8?label=GitHub&logo=github)](https://github.com/shadowsocks/v2ray-plugin)

## Getting Started

### Pull image
```
docker pull ghcr.io/hmbsbige/shadowsocks
```

### Run
```
docker run -itd \
--restart=always \
--name=ss \
--net=host \
ghcr.io/hmbsbige/shadowsocks \
server \
-U \
-s "0.0.0.0:23333" \
-k 114514 \
-m aes-128-gcm \
--plugin "v2ray-plugin" \
--plugin-opts "server;tls;host=github.com"
```

Or

```
docker run -itd \
--restart=always \
--name=ss \
-v ~/config:/config:ro \
--net=host \
ghcr.io/hmbsbige/shadowsocks \
server \
-c /config/ss.json
```

## Usage

### Shadowsocks
`ssservice` only

https://github.com/shadowsocks/shadowsocks-rust

### v2ray-plugin
https://github.com/shadowsocks/v2ray-plugin
