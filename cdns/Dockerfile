FROM alpine:edge as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget curl git go make \
        && git clone https://github.com/rnetx/cdns.git /usr/src/cdns && cd /usr/src/cdns && go build -o /usr/src/cdns/cdns -a -ldflags '-extldflags "-static"' \
        && git clone https://github.com/IrineSistiana/mosproxy.git /usr/src/mosproxy && cd /usr/src/mosproxy && go build -o /usr/src/mosproxy/mosproxy -a -ldflags '-extldflags "-static"' \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine:edge AS runtime
ENV MOSPROXY_JSONLOGGER=true
COPY --from=builder /usr/src/cdns/cdns /usr/bin/cdns
COPY --from=builder /usr/src/mosproxy/mosproxy /usr/bin/mosproxy
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates bash tzdata redis \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /rules \
        && wget -O /rules/gfw.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/cdns/gfw.conf \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/cdns/accelerated-domains.china.conf \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /cdns
EXPOSE 53 8090
ENTRYPOINT /entrypoint.sh
