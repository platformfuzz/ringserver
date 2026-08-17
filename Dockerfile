FROM earthscope/ringserver:4.5.6

USER root
COPY --chown=10000:10000 config/ringserver.conf /config/ringserver.conf
USER 10000

# SeedLink on 18000, DataLink on 16000. Override with RS_* env.
ENV RS_CONFIG_FILE=/config/ringserver.conf
