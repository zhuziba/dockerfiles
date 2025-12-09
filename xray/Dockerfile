FROM alpine:3.22
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates git tzdata curl wget bash unzip nginx supervisor \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /tmp/xray \
        && git clone https://github.com/xiongbao/we.dog \
        && mv we.dog/* /var/lib/nginx/html/ \
        && rm -rf /we.dog \
        && rm -rf /var/cache/apk/*
ADD index.html /wwwroot/index.html
ADD default.conf /etc/nginx/http.d/default.conf
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
