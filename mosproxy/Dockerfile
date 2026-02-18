FROM alpine:3.22 AS builder
RUN set -ex \
        && apk --no-cache add wget curl git go make \
        && git clone https://github.com/IrineSistiana/mosproxy.git /usr/src/mosproxy && cd /usr/src/mosproxy && go build -o /usr/src/mosproxy/mosproxy \
        && wget -O /tmp/gfw.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/cdns/gfw.conf \
        && wget -O /tmp/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/cdns/accelerated-domains.china.conf
##### Runtime
FROM alpine:3.22 AS runtime
ENV MOSPROXY_JSONLOGGER=true
COPY --from=builder /usr/src/mosproxy/mosproxy /usr/bin/mosproxy
COPY --from=builder /tmp/gfw.conf  /rules/gfw.conf 
COPY --from=builder /tmp/accelerated-domains.china.conf /rules/accelerated-domains.china.conf
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates bash tzdata \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /mosproxy
EXPOSE 53 8090
ENTRYPOINT ["/entrypoint.sh"]
