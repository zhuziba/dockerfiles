FROM alpine as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget curl git go make \
        && if [ $(arch) == aarch64 ]; then     wget -O /tmp/rcdns https://github.com/rnetx/rcdns/releases/download/v0.0.1/rcdns-0.0.1-aarch64-unknown-linux-gnu; fi \
        && if [ $(arch) == x86_64 ]; then     wget -O /tmp/rcdns https://github.com/rnetx/rcdns/releases/download/v0.0.1/rcdns-0.0.1-x86_64-unknown-linux-gnu; fi \
        && chmod +x /tmp/rcdns \
        && git clone https://github.com/yaotthaha/cdns.git /usr/src/cdns && cd /usr/src/cdns && go build -o /usr/src/cdns/cdns -a -ldflags '-extldflags "-static"' \
        && rm -rf /var/cache/apk/*
FROM alpine
COPY --from=builder /usr/src/cdns/cdns /usr/bin/cdns
COPY --from=builder /tmp/rcdns /usr/bin/rcdns
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates bash tzdata redis \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \  
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /cdns
EXPOSE 53 8090
ENTRYPOINT /entrypoint.sh
