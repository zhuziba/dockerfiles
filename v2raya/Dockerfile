FROM alpine:3.24.4 AS builder
ARG V2RAYA_VERSION=2.5.16
ARG V2RAY_RULES_RELEASE=202611232203
RUN set -ex \
        && apk add  v2ray wget \
        && wget -O /tmp/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${V2RAY_RULES_RELEASE}/geoip.dat \
        && wget -O /tmp/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${V2RAY_RULES_RELEASE}/geosite.dat \
        && if [ $(arch) == aarch64 ]; then      wget -O /tmp/v2raya https://github.com/v2rayA/v2rayA/releases/download/v${V2RAYA_VERSION}/v2raya_linux_arm64_${V2RAYA_VERSION}; fi \
        && if [ $(arch) == x86_64 ]; then     wget -O /tmp/v2raya https://github.com/v2rayA/v2rayA/releases/download/v${V2RAYA_VERSION}/v2raya_linux_x64_${V2RAYA_VERSION}; fi \
        && chmod +x /tmp/v2raya \
        && mv /tmp/v2raya /usr/bin/v2raya \
        && rm -rf /var/cache/apk/*

##### Runtime
FROM alpine:3.24.4 AS runtime
ENV PATH=$PATH:/usr/share/v2ray
COPY --from=builder /usr/bin/v2ray /usr/share/v2ray/v2ray
COPY --from=builder /tmp/geoip.dat /usr/local/share/v2ray/geoip.dat
COPY --from=builder /tmp/geosite.dat /usr/local/share/v2ray/geosite.dat
COPY --from=builder /usr/bin/v2raya /usr/bin/v2raya
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
