FROM alpine
ADD default.conf /etc/nginx/http.d/default.conf
RUN set -ex \
        && apk update \
        && apk upgrade \
        && apk add --no-cache --virtual .build-deps ca-certificates git nginx curl wget unzip \
        && apk add tzdata \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /tmp/xray \
        && git clone https://github.com/xiongbao/we.dog \
        && mv we.dog/* /var/lib/nginx/html/ \
        && rm -rf /we.dog
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
