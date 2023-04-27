FROM alpine as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add go git musl-dev gcc g++ \
        && git clone https://github.com/v2fly/v2ray-core.git /usr/src/v2ray && cd /usr/src/v2ray && go build -v -o /usr/src/v2ray/v2ray -trimpath -ldflags "-s -w" ./main

##### Runtime
FROM alpine
ENV VER=2.0.5 \
    PATH=$PATH:/usr/share/v2ray
COPY --from=builder /usr/src/v2ray/v2ray /usr/share/v2ray/v2ray
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget iptables bash unzip \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /etc/v2raya \
        && mkdir -p /etc/v2raya-web \
        && mkdir -p /tmp/v2ray \
        && mkdir -p /usr/share/v2ray \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/favicon.ico \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/index.html \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/CNAME \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/robots.txt \
        && mkdir -p /usr/local/share/v2ray \
        && wget -O /usr/local/share/v2ray/geoip.dat https://raw.githubusercontent.com/v2fly/geoip/release/geoip.dat \
        && wget -O /usr/local/share/v2ray/geosite.dat https://raw.githubusercontent.com/v2fly/domain-list-community/release/dlc.dat \
        && rm -rf /var/cache/apk/*
VOLUME /etc/v2raya
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
EXPOSE 53 2017 20170 20171 20172
