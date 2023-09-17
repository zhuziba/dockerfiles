FROM alpine:edge as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget curl libc-dev git go upx make \
        && git clone https://github.com/yaotthaha/cdns.git /usr/src/cdns && cd /usr/src/cdns && go build -o /usr/src/cdns/cdns \
        && rm -rf /var/cache/apk/*
FROM alpine
COPY --from=builder /usr/src/cdns/cdns /usr/bin/cdns
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates bash tzdata libc6-compat \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \  
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /cdns
EXPOSE 53 8090
ENTRYPOINT /entrypoint.sh
