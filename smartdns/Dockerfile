FROM alpine:edge AS builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add cargo git wget \
        && if [ $(arch) == aarch64 ]; then     wget -O /tmp/smartdns https://github.com/pymumu/smartdns/releases/latest/download/smartdns-aarch64; fi \
        && if [ $(arch) == x86_64 ]; then     wget -O /tmp/smartdns https://github.com/pymumu/smartdns/releases/latest/download/smartdns-x86_64; fi \
        && wget -O /tmp/accelerated-domains.china.conf https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/china-list.txt \
        && wget -O /tmp/gfw.conf https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt \
        && chmod +x /tmp/smartdns \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine AS runtime
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /tmp/smartdns /tmp/smartdns
COPY --from=builder /tmp/accelerated-domains.china.conf /rules/accelerated-domains.china.conf
COPY --from=builder /tmp/gfw.conf /rules/gfw.conf
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata bash openrc \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /smartdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /smartdns
EXPOSE 53
ENTRYPOINT ["/entrypoint.sh"]
