FROM alpine:3.23
ARG DRPYS_COMMIT=295f2b7047e14122d542a7736cb931e81abcf85c
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata git bash nodejs npm curl wget make g++ gcc libsecret-dev python3 \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && git clone https://github.com/Hululu007/drpy-node /usr/local/app \
        && git -C /usr/local/app checkout --detach "$DRPYS_COMMIT" \
        && cd /usr/local/app  && npm ci && npm install -g pm2@7.0.4 \
        && chmod +x /entrypoint.sh \
        && rm -rf /usr/local/app/soft/7z2409-x64.exe \
        && rm -rf /usr/local/app/soft/runnerGo_win_x64.exe \
        && rm -rf /usr/local/app/drpy-node-admin /usr/local/app/drpy-node-bundle /usr/local/app/drpy-node-mcp /usr/local/app/drpy2-quickjs \
        && rm -rf /var/cache/apk/*
WORKDIR /drpys
EXPOSE 5757
ENTRYPOINT ["/entrypoint.sh"]
