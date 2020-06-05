FROM alpine:latest

ENV INIT_DIR=/initialized
VOLUME $INIT_DIR
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "docker-entrypoint.sh" ]
