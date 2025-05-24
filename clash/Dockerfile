FROM alpine:edge AS builder
ENV clash=1.19.9
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add git wget go \
        && if [ $(arch) == aarch64 ]; then     wget -P /usr/bin https://github.com/MetaCubeX/mihomo/releases/download/v$clash/mihomo-linux-arm64-v$clash.gz;     gunzip /usr/bin/mihomo-linux-arm64-v$clash.gz;     mv /usr/bin/mihomo-linux-arm64-v$clash /usr/bin/mihomo; fi \
        && if [ $(arch) == x86_64 ]; then     wget -P /usr/bin https://github.com/MetaCubeX/mihomo/releases/download/v$clash/mihomo-linux-amd64-v$clash.gz;     gunzip /usr/bin/mihomo-linux-amd64-v$clash.gz;     mv /usr/bin/mihomo-linux-amd64-v$clash /usr/bin/mihomo; fi \
        && chmod +x /usr/bin/mihomo \
        && wget -P /tmp https://github.com/Loyalsoldier/geoip/releases/latest/download/Country.mmdb \
        && wget -P /tmp https://github.com/MetaCubeX/yacd/archive/gh-pages.zip \
        && rm -rf /var/cache/apk/*

FROM alpine:edge
ENV iptables=true \
    tun=false
ADD /script/iptables.sh /tmp/iptables.sh
COPY --from=builder /usr/bin/mihomo /usr/bin/mihomo
COPY --from=builder /tmp/Country.mmdb /tmp/Country.mmdb
COPY --from=builder /tmp/gh-pages.zip  /tmp/gh-pages.zip
ADD /entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget bash unzip iptables \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && chmod +x /tmp/iptables.sh \
        && chmod +x /entrypoint.sh
VOLUME /root/.config/mihomo
EXPOSE 53 7890 7891 7892 7893 9090
ENTRYPOINT /entrypoint.sh
