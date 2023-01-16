FROM alpine
ADD default.conf /etc/nginx/http.d/default.conf
RUN set -ex \
        && apk update \
        && apk upgrade \
        && apk add --no-cache --virtual .build-deps ca-certificates git nginx curl wget bash unzip \
        && apk add tzdata \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /tmp/xray \
        && mkdir -p /etc/caddy
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
