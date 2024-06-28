FROM alpine:edge AS builder
LABEL stage=go-builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget curl \
        && if [ $(arch) == aarch64 ]; then      curl -L -H "Cache-Control: no-cache" -o /alist.tar.gz https://github.com/alist-org/alist/releases/download/v3.35.0/alist-linux-arm64.tar.gz; fi \
        && if [ $(arch) == x86_64 ]; then      curl -L -H "Cache-Control: no-cache" -o /alist.tar.gz https://github.com/alist-org/alist/releases/download/v3.35.0/alist-linux-amd64.tar.gzz; fi \
        && tar -zxvf alist.tar.gz \
        && chmod +x alist \
        && mv alist /usr/bin/alist \
        && rm -rf /var/cache/apk/*

FROM alpine
LABEL MAINTAINER="i@nn.ci"
VOLUME /opt/alist/data/
WORKDIR /opt/alist/
COPY --from=builder /usr/bin/alist /usr/bin/alist
ADD entrypoint.sh /entrypoint.sh
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache bash ca-certificates su-exec tzdata; \
    chmod +x /entrypoint.sh && \
    rm -rf /var/cache/apk/*
ENV PUID=0 PGID=0 UMASK=022
EXPOSE 5244
CMD [ "/entrypoint.sh" ]
