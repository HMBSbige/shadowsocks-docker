# shadowsocks-docker
[![Docker](https://github.com/HMBSbige/shadowsocks-docker/actions/workflows/Docker.yml/badge.svg)](https://github.com/HMBSbige/shadowsocks-docker/actions/workflows/Docker.yml)
[![Docker](https://img.shields.io/badge/Docker-shadowsocks-blue?label=Docker&logo=docker)](https://github.com/users/HMBSbige/packages/container/package/shadowsocks)
[![Github last commit date](https://img.shields.io/github/last-commit/HMBSbige/shadowsocks-docker.svg?label=Updated&logo=github)](https://github.com/HMBSbige/shadowsocks-docker/commits)

[![shadowsocks-rust](https://img.shields.io/badge/shadowsocks--rust-v1.10.5-dea584)](https://github.com/shadowsocks/shadowsocks-rust)
[![v2ray-plugin](https://img.shields.io/badge/v2ray--plugin-v1.3.1-00add8)](https://github.com/shadowsocks/v2ray-plugin)

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
-v /root/config:/config:ro \
--net=host \
ghcr.io/hmbsbige/shadowsocks \
-c /config/ss.json
```

## Usage

### Shadowsocks
`ssserver` only

https://github.com/shadowsocks/shadowsocks-rust

### v2ray-plugin
https://github.com/shadowsocks/v2ray-plugin
