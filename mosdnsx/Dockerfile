FROM alpine:edge AS builder
RUN set -ex \
        && apk add git curl wget go make \
        && git clone https://github.com/pmkol/mosdns-x.git /usr/src/mosdns-x && cd /usr/src/mosdns-x && go build -trimpath -o /usr/src/mosdns-x/mosdns -a -ldflags '-extldflags "-static"' \
        && mkdir -p /rules \
        && rm -rf /var/cache/apk/*

FROM alpine:3.22 AS runtime
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
