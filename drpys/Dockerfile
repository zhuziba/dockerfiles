FROM alpine:3.22
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/app/node_modules/.bin \
    TZ=Asia/Shanghai
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata git bash nodejs yarn curl wget \
        && apk add --no-cache php83 php83-cli php83-curl php83-mbstring php83-xml php83-pdo php83-pdo_mysql php83-pdo_sqlit php83-openssl php83-sqlite3 php83-json \
        && ln -sf /usr/bin/php83 /usr/bin/php \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && git clone https://github.com/hjdhnx/drpy-node /usr/local/app \
        && cd /usr/local/app && yarn && yarn add pm2 \
        && chmod +x /entrypoint.sh \
        && rm -rf /usr/local/app/soft/7z2409-x64.exe \
        && rm -rf /usr/local/app/soft/runnerGo_win_x64.exe \
        && rm -rf /var/cache/apk/*
WORKDIR /drpys
EXPOSE 5757
ENTRYPOINT ["/entrypoint.sh"]
