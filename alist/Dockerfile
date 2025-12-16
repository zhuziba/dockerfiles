FROM alpine:3.22
VOLUME /opt/openlist/data/
WORKDIR /opt/openlist/
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget curl bash su-exec musl-dev tzdata \
        && echo "Asia/Shanghai" > /etc/timezone \
        && if [ $(arch) == aarch64 ]; then      curl -L -H "Cache-Control: no-cache" -o /tmp/openlist.tar.gz https://github.com/OpenListTeam/OpenList/releases/download/v4.1.8/openlist-linux-musl-arm64.tar.gz; fi \
        && if [ $(arch) == x86_64 ]; then      curl -L -H "Cache-Control: no-cache" -o /tmp/openlist.tar.gz https://github.com/OpenListTeam/OpenList/releases/download/v4.1.8/openlist-linux-musl-amd64.tar.gz; fi \
        && tar -zxvf /tmp/openlist.tar.gz -C /tmp \
        && chmod +x /tmp/openlist \
        && chmod +x /entrypoint.sh \
        && mv /tmp/openlist /usr/bin/alist \
        && rm -rf /var/cache/apk/*
EXPOSE 5244
CMD [ "/entrypoint.sh" ]
