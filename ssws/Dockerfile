FROM alpine as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add go git musl-dev gcc g++ make automake \
        && git clone https://github.com/shadowsocks/shadowsocks-libev /usr/src/shadowsocks \
        && cd /usr/src/cdns && ./autogen.sh && ./configure --prefix=/usr/local --disable-documentation \
        && make -j$(getconf _NPROCESSORS_ONLN) \
        && make install
        
FROM alpine
COPY --from=builder /usr/local/ss-server /usr/bin/ss-server
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates git tzdata wget bash nginx \
        && apk add shadowsocks-libev-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && if [ $(arch) == x86_64 ]; then     wget -P /tmp  https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz;     tar -xvf /tmp/v2ray-plugin-linux-amd64-v1.3.2.tar.gz;     mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin;     chmod +x /usr/bin/v2ray-plugin;     rm -rf /tmp/v2ray-plugin-linux-amd64-v1.3.2.tar.gz; fi \
        && if [ $(arch) == aarch64 ]; then     wget -P /tmp  https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-arm64-v1.3.2.tar.gz;     tar -xvf /tmp/v2ray-plugin-linux-arm64-v1.3.2.tar.gz;     mv v2ray-plugin_linux_arm64 /usr/bin/v2ray-plugin;     chmod +x /usr/bin/v2ray-plugin;     rm -rf /tmp/v2ray-plugin-linux-arm64-v1.3.2.tar.gz; fi \
        && git clone https://github.com/xiongbao/we.dog \
        && mv we.dog/* /var/lib/nginx/html/ \
        && rm -rf /we.dog
ADD entrypoint.sh /entrypoint.sh
ADD default.conf /etc/nginx/http.d/default.conf
RUN chmod +x /entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
