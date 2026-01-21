FROM alpine:edge AS builder
RUN set -ex \
        && apk add git curl wget go make \
        && git clone https://github.com/IrineSistiana/mosdns.git /usr/src/mosdns && cd /usr/src/mosdns && go build -trimpath -o /usr/src/mosdns/mosdns -a -ldflags '-extldflags "-static"' \
        && mkdir -p /rules \
        && wget -O /rules/gfw.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/china-list.txt \
        && wget -O /rules/CN-ip-cidr.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/CN-ip-cidr.txt \
        && rm -rf /var/cache/apk/*

FROM alpine:3.22 AS runtime
COPY --from=builder /usr/src/mosdns/mosdns /usr/bin/mosdns
COPY --from=builder /rules/gfw.txt /rules/gfw.txt
COPY --from=builder /rules/CN-ip-cidr.txt /rules/CN-ip-cidr.txt
COPY --from=builder /rules/accelerated-domains.china.conf /rules/accelerated-domains.china.conf
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata dhcp bash nginx supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 53
ENTRYPOINT ["/entrypoint.sh"]
