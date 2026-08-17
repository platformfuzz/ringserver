# ringserver

![CI](https://github.com/platformfuzz/ringserver/actions/workflows/ci.yml/badge.svg)
![Build and Release](https://github.com/platformfuzz/ringserver/actions/workflows/build-and-release.yml/badge.svg)

Ringserver image built from EarthScope.

Listens on TCP 18000 (SeedLink) and TCP 16000 (DataLink). Ring files live under
`/data/ring`. Mount that path if the ring must survive restarts.

**Package:** [ghcr.io/platformfuzz/ringserver](https://github.com/platformfuzz/ringserver/pkgs/container/ringserver)

## Run

```bash
docker pull ghcr.io/platformfuzz/ringserver:latest
docker run --rm -p 18000:18000 -p 16000:16000 ghcr.io/platformfuzz/ringserver:latest
```

Ring size: `RS_RING_SIZE`. Write allow-list: `RS_WRITE_IP` (localhost if unset).
Config file: `RS_CONFIG_FILE` (default `/config/ringserver.conf`). See `ringserver -C`
for the full `RS_*` list.

## Build

```bash
docker build -t ringserver:test .
docker run --rm -p 18000:18000 -p 16000:16000 ringserver:test
```
