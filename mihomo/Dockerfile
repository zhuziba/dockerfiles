FROM alpine:3.23 AS builder
ARG CLASH_VERSION=1.19.32
ARG GEOIP_RELEASE=202610011501
ARG YACD_COMMIT=c70d55a0ba14efe6fc382966d47a035d5fd14faf
RUN set -ex \
    && apk --no-cache add curl wget \
    && ARCH=$(uname -m) \
    && case $ARCH in \
        aarch64) URL=https://github.com/MetaCubeX/mihomo/releases/download/v${CLASH_VERSION}/mihomo-linux-arm64-v${CLASH_VERSION}.gz ;; \
        x86_64) URL=https://github.com/MetaCubeX/mihomo/releases/download/v${CLASH_VERSION}/mihomo-linux-amd64-v${CLASH_VERSION}.gz ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && wget -O /usr/bin/mihomo.gz $URL \
    && gunzip /usr/bin/mihomo.gz \
    && chmod +x /usr/bin/mihomo \
    && wget -O /tmp/Country.mmdb https://github.com/Loyalsoldier/geoip/releases/download/${GEOIP_RELEASE}/Country.mmdb \
    && curl --fail --location --retry 3 \
        -H "Accept: application/octet-stream" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -o /tmp/geosite.dat \
        "https://api.github.com/repos/MetaCubeX/meta-rules-dat/releases/assets/604553113" \
    && echo "d8b751e6af6063bbacf0cbc23385fd37caac1c0e04e05292b5e97213a98ef5fc  /tmp/geosite.dat" | sha256sum -c - \
    && wget -O /tmp/gh-pages.zip https://github.com/MetaCubeX/Yacd-meta/archive/${YACD_COMMIT}.zip \
    && rm -rf /var/cache/apk/*

FROM alpine:3.23 AS runtime
ENV iptables=true \
    tun=false
COPY --from=builder /usr/bin/mihomo /usr/bin/mihomo
COPY --from=builder /tmp/Country.mmdb /tmp/Country.mmdb
COPY --from=builder /tmp/geosite.dat /tmp/geosite.dat
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
