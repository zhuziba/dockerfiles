FROM golang:1.26-alpine3.23 AS builder
ARG MOSDNS_VERSION=v5.3.4
RUN set -ex \
        && apk add --no-cache git curl wget make \
        && git clone --depth 1 --branch "$MOSDNS_VERSION" https://github.com/IrineSistiana/mosdns.git /usr/src/mosdns && cd /usr/src/mosdns && go build -trimpath -o /usr/src/mosdns/mosdns -a -ldflags '-extldflags "-static"' \
        && mkdir -p /rules \
        && wget -O /rules/gfw.txt https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202610010125/gfw.txt \
        && wget -O /rules/accelerated-domains.china.conf https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202610010125/china-list.txt \
        && wget -O /rules/CN-ip-cidr.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/03fe27da9913846aa42a5eb526e188295ea88bca/CN-ip-cidr.txt \
        && rm -rf /var/cache/apk/*

FROM alpine:3.23 AS runtime
COPY --from=builder /usr/src/mosdns/mosdns /usr/bin/mosdns
COPY --from=builder /rules/gfw.txt /rules/gfw.txt
COPY --from=builder /rules/CN-ip-cidr.txt /rules/CN-ip-cidr.txt
COPY --from=builder /rules/accelerated-domains.china.conf /rules/accelerated-domains.china.conf
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata bash nginx supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 53
ENTRYPOINT ["/entrypoint.sh"]
