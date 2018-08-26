FROM alpine:3.8

RUN apk add --update curl ca-certificates \
    && curl -L -o /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 \
    && chmod +x /usr/bin/confd \
    && mkdir -p /etc/confd

ONBUILD ADD templates /etc/confd/templates/
ONBUILD ADD conf.d /etc/confd/conf.d/

ENTRYPOINT ["confd"]
