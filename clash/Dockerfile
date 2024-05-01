FROM alpine:edge as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add git wget go \
        && git clone --branch Meta https://github.com/MetaCubeX/mihomo.git /usr/src/mihomo && cd /usr/src/mihomo && go mod download && go build -tags with_gvisor -o /usr/src/mihomo/mihomo -a -ldflags '-extldflags "-static"' \
        && wget -P /tmp https://github.com/Loyalsoldier/geoip/releases/latest/download/Country.mmdb \
        && wget -P /tmp https://github.com/MetaCubeX/yacd/archive/gh-pages.zip \
        && rm -rf /var/cache/apk/*

FROM alpine:edge
ENV iptables=true \
    tun=false
ADD /script/iptables.sh /tmp/iptables.sh
COPY --from=builder /usr/src/mihomo/mihomo /usr/bin/mihomo
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
