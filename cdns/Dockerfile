FROM alpine:edge AS builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add wget curl git go make \
        && if [ $(arch) == aarch64 ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://static.adguard.com/adguardhome/release/AdGuardHome_linux_arm64.tar.gz; fi \
        && if [ $(arch) == x86_64 ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz; fi \
        && tar -zxvf AdGuardHome.tar.gz \
        && chmod +x /AdGuardHome/AdGuardHome \
        #&& git clone https://github.com/rnetx/cdns.git /usr/src/cdns && cd /usr/src/cdns && go build -o /usr/src/cdns/cdns -a -ldflags '-extldflags "-static"' \
        && git clone https://github.com/IrineSistiana/mosproxy.git /usr/src/mosproxy && cd /usr/src/mosproxy && go build -o /usr/src/mosproxy/mosproxy \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine:edge AS runtime
ENV MOSPROXY_JSONLOGGER=true
#COPY --from=builder /usr/src/cdns/cdns /usr/bin/cdns
COPY --from=builder /usr/src/mosproxy/mosproxy /usr/bin/mosproxy
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates bash tzdata wget redis \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /rules \
        && wget -O /rules/gfw.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/cdns/gfw.conf \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/cdns/accelerated-domains.china.conf \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /cdns
EXPOSE 53 8090
ENTRYPOINT ["/entrypoint.sh"]
