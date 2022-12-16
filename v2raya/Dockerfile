FROM alpine
ENV VER=2.0.1 \
    PATH=$PATH:/usr/share/v2ray
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget iptables ip6tables bash unzip \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /etc/v2raya \
        && mkdir /etc/v2raya-web \
        && mkdir /tmp/v2ray \
        && mkdir /usr/share/v2ray \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/favicon.ico \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/index.html \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/CNAME \
        && wget -P /etc/v2raya-web https://raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/gui/public/robots.txt \
        && mkdir -p /usr/local/share/v2ray && touch /usr/local/share/v2ray/.copykeep \
        && rm -rf /var/cache/apk/*
VOLUME /etc/v2raya
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
EXPOSE 53 2017 8080 20170 20171 20172
