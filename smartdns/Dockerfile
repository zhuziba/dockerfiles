FROM alpine:3.23 AS builder
ARG SMARTDNS_VERSION=Release48.4
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget \
        && if [ $(arch) == aarch64 ]; then     wget -O /tmp/smartdns https://github.com/pymumu/smartdns/releases/download/${SMARTDNS_VERSION}/smartdns-aarch64; fi \
        && if [ $(arch) == x86_64 ]; then     wget -O /tmp/smartdns https://github.com/pymumu/smartdns/releases/download/${SMARTDNS_VERSION}/smartdns-x86_64; fi \
        && wget -O /tmp/accelerated-domains.china.conf https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202610010125/china-list.txt \
        && wget -O /tmp/gfw.conf https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202610010125/gfw.txt \
        && chmod +x /tmp/smartdns \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine:3.23 AS runtime
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /tmp/smartdns /tmp/smartdns
COPY --from=builder /tmp/accelerated-domains.china.conf /rules/accelerated-domains.china.conf
COPY --from=builder /tmp/gfw.conf /rules/gfw.conf
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata bash \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /smartdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /smartdns
EXPOSE 53
ENTRYPOINT ["/entrypoint.sh"]
