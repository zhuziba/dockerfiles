FROM alpine:3.23 AS builder
ENV VER=2.4.0 
RUN set -ex \
        && apk add  v2ray wget \
        && wget -O /tmp/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat \
        && wget -O /tmp/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat \
        && if [ $(arch) == aarch64 ]; then      wget https://github.com/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm64_$VER;     chmod +x /v2raya_linux_arm64_$VER;     mv /v2raya_linux_arm64_$VER /usr/bin/v2raya; fi \
        && if [ $(arch) == x86_64 ]; then     wget https://github.com/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_x64_$VER;     chmod +x /v2raya_linux_x64_$VER;     mv /v2raya_linux_x64_$VER /usr/bin/v2raya; fi \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/main/gui/public/favicon.ico \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/main/gui/public/index.html \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/main/gui/public/CNAME \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/main/gui/public/robots.txt \
        && rm -rf /var/cache/apk/*

##### Runtime
FROM alpine:3.23
ENV PATH=$PATH:/usr/share/v2ray
COPY --from=builder /usr/bin/v2ray /usr/share/v2ray/v2ray
COPY --from=builder /tmp/geoip.dat /usr/local/share/v2ray/geoip.dat
COPY --from=builder /tmp/geosite.dat /usr/local/share/v2ray/geosite.dat
COPY --from=builder /usr/bin/v2raya /usr/bin/v2raya
COPY --from=builder /etc/v2raya-web/favicon.ico /etc/v2raya-web/favicon.ico
COPY --from=builder /etc/v2raya-web/index.html /etc/v2raya-web/index.html
COPY --from=builder /etc/v2raya-web/CNAME /etc/v2raya-web/CNAME
COPY --from=builder /etc/v2raya-web/robots.txt /etc/v2raya-web/robots.txt
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata iptables iptables-legacy bash supervisor \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /etc/v2raya
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 53 2017 20170 20171 20172
