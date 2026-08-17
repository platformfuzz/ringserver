# Debian bookworm + EarthScope ringserver. Pin RINGSERVER_VERSION.

ARG BASE=debian:bookworm-slim

FROM ${BASE} AS buildenv
ARG RINGSERVER_VERSION=4.5.6
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      clang \
      git \
      make \
      netbase \
 && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "v${RINGSERVER_VERSION}" \
      https://github.com/EarthScope/ringserver.git /build \
 && cd /build \
 && CFLAGS="-O3" make -j

FROM ${BASE}
ARG DEBIAN_FRONTEND=noninteractive
ARG UID=10000
ARG GID=10000
ARG USERNAME=containeruser

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      netbase \
      procps \
 && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

COPY --from=buildenv /build/ringserver /ringserver
COPY config/ringserver.conf /config/ringserver.conf

RUN groupadd --gid "${GID}" "${USERNAME}" \
 && adduser --uid "${UID}" --gid "${GID}" "${USERNAME}" \
 && mkdir -p /data/ring \
 && chown -R "${UID}:${GID}" /data /config

WORKDIR /data
EXPOSE 18000 16000
USER ${USERNAME}

# SeedLink-only on 18000, DataLink-only on 16000. Override with RS_* env.
ENV RS_CONFIG_FILE=/config/ringserver.conf
ENV RS_RING_DIRECTORY=/data/ring
ENV RS_SEEDLINK_PORT=18000
ENV RS_DATALINK_PORT=16000

ENTRYPOINT ["/ringserver"]
