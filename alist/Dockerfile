FROM alpine
VOLUME /opt/alist/data/
WORKDIR /opt/alist/
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget curl bash su-exec musl-dev tzdata \
        && echo "Asia/Shanghai" > /etc/timezone \
        && if [ $(arch) == aarch64 ]; then      curl -L -H "Cache-Control: no-cache" -o /tmp/alist.tar.gz https://github.com/alist-org/alist/releases/download/v3.44.0/alist-linux-musl-arm64.tar.gz; fi \
        && if [ $(arch) == x86_64 ]; then      curl -L -H "Cache-Control: no-cache" -o /tmp/alist.tar.gz https://github.com/alist-org/alist/releases/download/v3.44.0/alist-linux-musl-amd64.tar.gz; fi \
        && tar -zxvf /tmp/alist.tar.gz -C /tmp \
        && chmod +x /tmp/alist \
        && chmod +x /entrypoint.sh \
        && mv /tmp/alist /usr/bin/alist \
        && rm -rf /var/cache/apk/*
EXPOSE 5244
CMD [ "/entrypoint.sh" ]
