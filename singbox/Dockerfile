FROM alpine
ENV singbox=1.1
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl git nginx openrc bash iptables \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /singbox \
        && if [ $(arch) == x86_64 ]; then     wget -P /tmp  https://github.com/SagerNet/sing-box/releases/download/v$singbox/sing-box-$singbox-linux-amd64.tar.gz;     tar -xvf /tmp/sing-box-$singbox-linux-amd64.tar.gz;     mv /sing-box-$singbox-linux-amd64/sing-box /usr/bin/sing-box;     chmod +x /usr/bin/sing-box;     rm -rf /tmp/sing-box-$singbox-linux-amd64.tar.gz; fi \
        && if [ $(arch) == aarch64 ]; then    wget -P /tmp  https://github.com/SagerNet/sing-box/releases/download/v$singbox/sing-box-$singbox-linux-arm64.tar.gz;     tar -xvf /tmp/sing-box-$singbox-linux-arm64.tar.gz;     mv /sing-box-$singbox-linux-arm64/sing-box /usr/bin/sing-box;     chmod +x /usr/bin/sing-box;     rm -rf /tmp/sing-box-$singbox-linux-arm64.tar.gz; fi \
        && if [ $(arch) == s390x ]; then    wget -P /tmp  https://github.com/SagerNet/sing-box/releases/download/v$singbox/sing-box-$singbox-linux-s390x.tar.gz;     tar -xvf /tmp/sing-box-$singbox-linux-s390x.tar.gz;     mv /sing-box-$singbox-linux-s390x/sing-box /usr/bin/sing-box;     chmod +x /usr/bin/sing-box;     rm -rf /tmp/sing-box-$singbox-linux-s390x.tar.gz; fi \
        && git clone https://github.com/xiongbao/we.dog \
        && mv we.dog/* /var/lib/nginx/html/ \
        && rm -rf /we.dog \
        && rm -rf /var/cache/apk/* 
VOLUME /singbox
EXPOSE 80
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
