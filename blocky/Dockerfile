FROM golang:1.26-alpine3.23 AS builder
ARG BLOCKY_VERSION=v0.35.0
RUN set -ex \
        && apk add --no-cache git \
        && git clone --depth 1 --branch "$BLOCKY_VERSION" https://github.com/0xERR0R/blocky.git /usr/src/blocky && cd /usr/src/blocky && go build -trimpath -o /usr/src/blocky/blocky -a -ldflags '-extldflags "-static"'
##### Runtime
FROM alpine:3.23 AS runtime
COPY --from=builder /usr/src/blocky/blocky /usr/bin/blocky
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget redis bash supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /blocky \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /blocky
EXPOSE 53
ENTRYPOINT ["/entrypoint.sh"]
