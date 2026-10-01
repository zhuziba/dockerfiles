FROM golang:1.26-alpine3.23 AS builder
ARG MOSDNSX_VERSION=v26.05.25
RUN set -ex \
        && apk add --no-cache git make \
        && git clone --depth 1 --branch "$MOSDNSX_VERSION" https://github.com/pmkol/mosdns-x.git /usr/src/mosdns-x && cd /usr/src/mosdns-x && go build -trimpath -o /usr/src/mosdns-x/mosdns -a -ldflags '-extldflags "-static"' \
        && rm -rf /var/cache/apk/*

FROM alpine:3.23 AS runtime
COPY --from=builder /usr/src/mosdns-x/mosdns /usr/bin/mosdns
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata dhcp bash supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /mosdnsx \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /mosdnsx
EXPOSE 53 80
ENTRYPOINT ["/entrypoint.sh"]
