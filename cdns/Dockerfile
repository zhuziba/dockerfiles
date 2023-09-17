FROM alpine:edge as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget curl \
        && if [ $(arch) == aarch64 ]; then      curl -L -H "Cache-Control: no-cache" -o /cdns-linux.tar.gz https://github.com/yaotthaha/cdns/releases/download/v0.0.3/cdns-linux-arm64.tar.gz; fi \
        && if [ $(arch) == x86_64 ]; then      curl -L -H "Cache-Control: no-cache" -o /cdns-linux.tar.gz https://github.com/yaotthaha/cdns/releases/download/v0.0.3/cdns-linux-amd64.tar.gz; fi \
        && tar -zxvf cdns-linux.tar.gz \
        && if [ $(arch) == aarch64 ]; then      mv /cdns-linux-arm64 /tmp/cdns; fi \
        && if [ $(arch) == x86_64 ]; then      mv /cdns-linux-amd64 /tmp/cdns; fi \
        && chmod +x /tmp/cdns \
        && rm -rf /var/cache/apk/*
FROM alpine
COPY --from=builder /tmp/cdns /usr/bin/cdns
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates bash tzdata \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \  
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /cdns
EXPOSE 53 8090
ENTRYPOINT /entrypoint.sh
