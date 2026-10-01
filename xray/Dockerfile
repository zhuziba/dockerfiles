FROM alpine:3.23 AS builder
ARG XRAY_VERSION=26.3.27
ARG TARGETARCH
RUN set -ex \
        && apk add --no-cache ca-certificates curl unzip \
        && case "$TARGETARCH" in \
            amd64) URL="https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" ;; \
            arm64) URL="https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-arm64-v8a.zip" ;; \
            s390x) URL="https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-s390x.zip" ;; \
            *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
        esac \
        && curl --fail --location --retry 3 -o /tmp/Xray.zip "$URL" \
        && unzip -q /tmp/Xray.zip -d /tmp/xray \
        && chmod +x /tmp/xray/xray

FROM alpine:3.23
COPY --from=builder /tmp/xray/xray /usr/bin/xray
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates git tzdata bash nginx supervisor \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && git clone https://github.com/xiongbao/we.dog /tmp/we.dog \
        && git -C /tmp/we.dog checkout --detach fa4153f53a05e35ba863746298a21d2b20af3879 \
        && mv /tmp/we.dog/* /var/lib/nginx/html/ \
        && rm -rf /tmp/we.dog \
        && rm -rf /var/cache/apk/*
ADD index.html /wwwroot/index.html
ADD default.conf /etc/nginx/http.d/default.conf
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
