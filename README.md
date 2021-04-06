# shadowsocks-docker

shadowsocks + v2ray-plugin

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
