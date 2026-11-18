FROM alpine:3.24
ARG OPENLIST_VERSION=4.2.9
VOLUME /opt/openlist/data/
WORKDIR /opt/openlist/
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
        && apk update -f && apk upgrade \
        && apk --no-cache add curl bash musl-dev tzdata \
        && echo "Asia/Shanghai" > /etc/timezone \
        && ARCH=$(arch) \
        && case "$ARCH" in \
            aarch64) OPENLIST_ARCH=arm64; OPENLIST_MD5=065928168516f94398ee74110f2a7ade ;; \
            x86_64) OPENLIST_ARCH=amd64; OPENLIST_MD5=7c247e93bb5db4a8c503529abd5a5e91 ;; \
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
