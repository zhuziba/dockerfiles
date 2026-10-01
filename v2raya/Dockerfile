FROM alpine:3.23 AS builder
ARG V2RAYA_VERSION=2.4.7
ARG V2RAY_RULES_RELEASE=202610010125
ARG V2RAYA_GUI_COMMIT=94693ebbe11200b0a712a010d5c353a1a5b367a2
RUN set -ex \
        && apk add  v2ray wget \
        && wget -O /tmp/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${V2RAY_RULES_RELEASE}/geoip.dat \
        && wget -O /tmp/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${V2RAY_RULES_RELEASE}/geosite.dat \
        && if [ $(arch) == aarch64 ]; then      wget -O /tmp/v2raya https://github.com/v2rayA/v2rayA/releases/download/v${V2RAYA_VERSION}/v2raya_linux_arm64_${V2RAYA_VERSION}; fi \
        && if [ $(arch) == x86_64 ]; then     wget -O /tmp/v2raya https://github.com/v2rayA/v2rayA/releases/download/v${V2RAYA_VERSION}/v2raya_linux_x64_${V2RAYA_VERSION}; fi \
        && chmod +x /tmp/v2raya \
        && mv /tmp/v2raya /usr/bin/v2raya \
        && mkdir -p /etc/v2raya-web \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/${V2RAYA_GUI_COMMIT}/gui/public/favicon.ico \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/${V2RAYA_GUI_COMMIT}/gui/index.html \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/${V2RAYA_GUI_COMMIT}/gui/public/CNAME \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/${V2RAYA_GUI_COMMIT}/gui/public/robots.txt \
        && rm -rf /var/cache/apk/*

##### Runtime
FROM alpine:3.23 AS runtime
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
