FROM alpine:edge as builder
ENV clash=2023.06.30
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget \
        &&  if [ $(arch) == aarch64 ]; then     wget -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-arm64-$clash.gz;     gunzip /usr/bin/clash-linux-arm64-$clash.gz;     mv /usr/bin/clash-linux-arm64-$clash /usr/bin/clash; fi \
        && if [ $(arch) == x86_64 ]; then     wget -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-amd64-$clash.gz;     gunzip /usr/bin/clash-linux-amd64-$clash.gz;     mv /usr/bin/clash-linux-amd64-$clash /usr/bin/clash; fi \
        && chmod +x /usr/bin/clash \
        && wget -P /tmp https://github.com/Loyalsoldier/geoip/releases/latest/download/Country.mmdb \
        && wget -P /tmp https://github.com/haishanh/yacd/releases/download/v0.3.8/yacd.tar.xz \
        && rm -rf /var/cache/apk/*

FROM alpine
ENV iptables=true \
    tun=false
ADD /script/iptables.sh /tmp/iptables.sh
COPY --from=builder /usr/bin/clash /usr/bin/clash
COPY --from=builder /tmp/Country.mmdb /tmp/Country.mmdb
COPY --from=builder /tmp/yacd.tar.xz  /tmp/yacd.tar.xz
ADD /entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget bash iptables \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && chmod +x /tmp/iptables.sh \
        && chmod +x /entrypoint.sh
VOLUME /root/.config/clash
EXPOSE 53 7890 7891 7892 7893 9090
ENTRYPOINT /entrypoint.sh
