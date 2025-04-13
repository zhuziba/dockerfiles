FROM alpine:edge AS builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add git gcc g++ v2ray \
        && rm -rf /var/cache/apk/*

##### Runtime
FROM alpine
ENV VER=2.2.6.7 \
    PATH=$PATH:/usr/share/v2ray
COPY --from=builder /usr/bin/v2ray /usr/share/v2ray/v2ray
COPY --from=builder /usr/share/v2ray/geoip.dat /usr/local/share/v2ray/geoip.dat
COPY --from=builder /usr/share/v2ray/geosite.dat /usr/local/share/v2ray/geosite.dat
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget iptables iptables-legacy bash supervisor \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /etc/v2raya \
        && mkdir -p /etc/v2raya-web \
        && mkdir -p /tmp/v2ray \
        && mkdir -p /usr/share/v2ray \
        && chmod +x /entrypoint.sh \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/favicon.ico \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/index.html \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/CNAME \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/robots.txt \
        && if [ $(arch) == aarch64 ]; then      wget https://github.com/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm64_$VER;     chmod +x /v2raya_linux_arm64_$VER;     mv /v2raya_linux_arm64_$VER /usr/bin/v2raya; fi \
        && if [ $(arch) == x86_64 ]; then     wget https://github.com/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_x64_$VER;     chmod +x /v2raya_linux_x64_$VER;     mv /v2raya_linux_x64_$VER /usr/bin/v2raya; fi \
        && rm -rf /var/cache/apk/*
VOLUME /etc/v2raya
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 53 2017 20170 20171 20172
