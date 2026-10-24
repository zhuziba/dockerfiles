FROM alpine:3.24
ARG OPENLIST_VERSION=4.2.8
VOLUME /opt/openlist/data/
WORKDIR /opt/openlist/
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
        && apk update -f && apk upgrade \
        && apk add wget curl bash musl-dev tzdata \
        && echo "Asia/Shanghai" > /etc/timezone \
        && ARCH=$(arch) \
        && case "$ARCH" in \
            aarch64) OPENLIST_ARCH=arm64; OPENLIST_MD5=f926f3a3a8a121e63be228c43211b374 ;; \
            x86_64) OPENLIST_ARCH=amd64; OPENLIST_MD5=e35ce86eb44358dd512de84be004b134 ;; \
            *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;; \
        esac \
        && OPENLIST_FILE="openlist-linux-musl-${OPENLIST_ARCH}.tar.gz" \
        && curl --fail --location --retry 3 -H "Cache-Control: no-cache" \
            -o /tmp/openlist.tar.gz \
            "https://github.com/OpenListTeam/OpenList/releases/download/v${OPENLIST_VERSION}/${OPENLIST_FILE}" \
        && echo "${OPENLIST_MD5}  /tmp/openlist.tar.gz" | md5sum -c - \
        && tar -zxvf /tmp/openlist.tar.gz -C /tmp \
        && chmod +x /tmp/openlist \
        && chmod +x /entrypoint.sh \
        && mv /tmp/openlist /usr/bin/openlist \
        && rm -rf /var/cache/apk/* \
        && rm -rf /tmp/*
EXPOSE 5244
CMD [ "/entrypoint.sh" ]
