FROM alpine:3.22
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/app/node_modules/.bin \
    TZ=Asia/Shanghai
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata git bash nodejs yarn curl wget \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && git clone https://github.com/hjdhnx/drpy-node /usr/local/app \
        && cd /usr/local/app && yarn && yarn add pm2 \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
WORKDIR /drpys
EXPOSE 5757
ENTRYPOINT ["/entrypoint.sh"]
