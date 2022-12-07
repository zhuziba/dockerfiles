FROM alpine:edge
ADD /init/mosdns /etc/init.d/mosdns
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash iptables nginx openrc \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && if [ $(arch) == x86_64 ]; then    wget -P /tmp  https://github.com/IrineSistiana/mosdns/releases/latest/download/mosdns-linux-amd64.zip;     unzip /tmp/mosdns-linux-amd64.zip -d /tmp;     rm -rf /tmp/mosdns-linux-arm64.zip;     mv /tmp/mosdns /usr/bin/mosdns;     chmod +x /usr/bin/mosdns; fi \
        && if [ $(arch) == aarch64 ]; then    wget -P /tmp  https://github.com/IrineSistiana/mosdns/releases/latest/download/mosdns-linux-arm64.zip;     unzip /tmp/mosdns-linux-arm64.zip -d /tmp;     rm -rf /tmp/mosdns-linux-arm64.zip;     mv /tmp/mosdns /usr/bin/mosdns;     chmod +x /usr/bin/mosdns; fi \
        && mkdir /mosdns \
        && chmod +x /etc/init.d/mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 53
ENTRYPOINT /entrypoint.sh
