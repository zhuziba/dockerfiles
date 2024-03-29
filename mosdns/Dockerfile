FROM alpine as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add git curl go make \
        && if [ $(arch) == aarch64 ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://static.adguard.com/adguardhome/edge/AdGuardHome_linux_arm64.tar.gz; fi \
        && if [ $(arch) == x86_64 ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://static.adguard.com/adguardhome/edge/AdGuardHome_linux_amd64.tar.gz; fi \
        && tar -zxvf AdGuardHome.tar.gz \
        && chmod +x /AdGuardHome/AdGuardHome \
        && if [ $(arch) == aarch64 ]; then     wget -O /tmp/smartdns https://github.com/pymumu/smartdns/releases/download/Release45/smartdns-aarch64; fi \
        && if [ $(arch) == x86_64 ]; then     wget -O /tmp/smartdns https://github.com/pymumu/smartdns/releases/download/Release45/smartdns-x86_64; fi \
        && chmod +x /tmp/smartdns \
        && git clone https://github.com/IrineSistiana/mosdns.git /usr/src/mosdns && cd /usr/src/mosdns && go build -o /usr/src/mosdns/mosdns -a -ldflags '-extldflags "-static"' \
        && rm -rf /var/cache/apk/*

FROM alpine as runtime
COPY --from=builder /usr/src/mosdns/mosdns /usr/bin/mosdns
COPY --from=builder /AdGuardHome/AdGuardHome /usr/bin/AdGuardHome
COPY --from=builder /tmp/smartdns /usr/bin/smartdns
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget dhcp bash frp redis supervisor \
        #&& apk --no-cache add -f vector loki loki-promtail --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /rules \
        && wget -O /rules/gfw.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/gfw.txt \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/accelerated-domains.china.conf \
        && wget -O /rules/CN-ip-cidr.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/CN-ip-cidr.txt \
        && mkdir -p /mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /usr/bin/frps \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 53 80
ENTRYPOINT /entrypoint.sh
