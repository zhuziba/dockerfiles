FROM alpine:3.23
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata git bash nodejs npm  \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && npm install -g bun && npm install -g pm2 \
        && git clone https://github.com/hjdhnx/drpy-node-house /usr/local/app \
        && cd /usr/local/app  && bun install\
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
WORKDIR /drpys
EXPOSE 5678
ENTRYPOINT ["/entrypoint.sh"]
