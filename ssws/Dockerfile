FROM alpine:3.24.4 AS builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add shadowsocks-libev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing
        
FROM alpine:3.24.4 AS runtime
ARG V2RAY_PLUGIN_VERSION=1.5.0
COPY --from=builder /usr/bin/ss-server /usr/bin/ss-server
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates git tzdata wget bash nginx \
        #&& apk add shadowsocks-libev-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        && apk add --no-cache shadowsocks-libev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && ARCH=$(arch) \
        && case "$ARCH" in \
            x86_64) PLUGIN_ARCH=amd64; PLUGIN_SHA256=f326c48a0f91f8ab536a864c6a2dba6b587ea1df537b2c43af0bfb7922ed05c4 ;; \
            aarch64) PLUGIN_ARCH=arm64; PLUGIN_SHA256=96870e810a548e4f7e186016b1df76b24b59a60ffd9cd852586ef830479aeff6 ;; \
            *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;; \
        esac \
        && PLUGIN_FILE="v2ray-plugin-linux-${PLUGIN_ARCH}-v${V2RAY_PLUGIN_VERSION}.tar.gz" \
        && wget -P /tmp "https://github.com/shadowsocks/v2ray-plugin/releases/download/v${V2RAY_PLUGIN_VERSION}/${PLUGIN_FILE}" \
        && echo "${PLUGIN_SHA256}  /tmp/${PLUGIN_FILE}" | sha256sum -c - \
        && tar -xzf "/tmp/${PLUGIN_FILE}" -C /tmp \
        && mv "/tmp/v2ray-plugin_linux_${PLUGIN_ARCH}" /usr/bin/v2ray-plugin \
        && chmod +x /usr/bin/v2ray-plugin \
        && rm -f "/tmp/${PLUGIN_FILE}" "/tmp/._v2ray-plugin_linux_${PLUGIN_ARCH}" \
        && git clone https://github.com/xiongbao/we.dog /tmp/we.dog \
        && git -C /tmp/we.dog checkout --detach fa4153f53a05e35ba863746298a21d2b20af3879 \
        && mv /tmp/we.dog/* /var/lib/nginx/html/ \
        && rm -rf /tmp/we.dog
ADD entrypoint.sh /entrypoint.sh
ADD default.conf /etc/nginx/http.d/default.conf
RUN chmod +x /entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
