FROM alpine
LABEL MAINTAINER="i@nn.ci"
VOLUME /opt/alist/data/
WORKDIR /opt/alist/
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget curl bash su-exec tzdata \
        && if [ $(arch) == aarch64 ]; then      curl -L -H "Cache-Control: no-cache" -o /tmp/alist.tar.gz https://github.com/alist-org/alist/releases/download/v3.35.0/alist-linux-arm64.tar.gz; fi \
        && if [ $(arch) == x86_64 ]; then      curl -L -H "Cache-Control: no-cache" -o /tmp/alist.tar.gz https://github.com/alist-org/alist/releases/download/v3.35.0/alist-linux-amd64.tar.gz; fi \
        && tar -zxvf /tmp/alist.tar.gz \
        && chmod +x alist \
        && chmod +x /entrypoint.sh \
        && mv alist /usr/bin/alist \
        && rm -rf /var/cache/apk/*
ENV PUID=0 PGID=0 UMASK=022
EXPOSE 5244
CMD [ "/entrypoint.sh" ]
