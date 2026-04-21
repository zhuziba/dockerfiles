FROM alpine:3.23 AS builder
ARG CLASH_VERSION=1.19.24
RUN set -ex \
    && apk --no-cache add wget \
    && ARCH=$(uname -m) \
    && case $ARCH in \
        aarch64) URL=https://github.com/MetaCubeX/mihomo/releases/download/v${CLASH_VERSION}/mihomo-linux-arm64-v${CLASH_VERSION}.gz ;; \
        x86_64) URL=https://github.com/MetaCubeX/mihomo/releases/download/v${CLASH_VERSION}/mihomo-linux-amd64-v${CLASH_VERSION}.gz ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && wget -O /usr/bin/mihomo.gz $URL \
    && gunzip /usr/bin/mihomo.gz \
    && chmod +x /usr/bin/mihomo \
    && wget -O /tmp/Country.mmdb https://github.com/Loyalsoldier/geoip/releases/latest/download/Country.mmdb \
    && wget -O /tmp/gh-pages.zip https://github.com/MetaCubeX/yacd/archive/gh-pages.zip \
    && rm -rf /var/cache/apk/*

FROM alpine:3.23
ENV iptables=true \
    tun=false
COPY --from=builder /usr/bin/mihomo /usr/bin/mihomo
COPY --from=builder /tmp/Country.mmdb /tmp/Country.mmdb
COPY --from=builder /tmp/gh-pages.zip /tmp/gh-pages.zip
COPY script/iptables.sh /tmp/iptables.sh
COPY entrypoint.sh /entrypoint.sh
RUN set -ex \
    && apk --no-cache add ca-certificates tzdata bash iptables \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && chmod +x /tmp/iptables.sh /entrypoint.sh
VOLUME /root/.config/mihomo
EXPOSE 53 7890 7891 7892 7893 9090
ENTRYPOINT ["/entrypoint.sh"]
