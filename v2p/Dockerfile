FROM alpine:3.24.4 AS runtime
ARG ELECV2P_COMMIT=3da4b80a58ff77a6acc5593ff484acfc94adcb27
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/app/node_modules/.bin \
    TZ=Asia/Shanghai
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata git bash nodejs yarn curl wget coreutils moreutils perl \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && git clone https://github.com/elecV2/elecV2P.git /usr/local/app \
        && git -C /usr/local/app checkout --detach "$ELECV2P_COMMIT" \
        && sed -i "s/60000/0/g" /usr/local/app/func/exec.js \
        && cd /usr/local/app && yarn \
        && cp -r /usr/local/app/script/JSFile /tmp \
        && cp -r /usr/local/app/script/Lists /tmp \
        && cp -r /usr/local/app/script/Shell /tmp \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
WORKDIR /usr/local/app
EXPOSE 80 8001 8002
ENTRYPOINT ["/entrypoint.sh"]
