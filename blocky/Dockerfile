FROM alpine:edge
ENV blocky=0.20
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /blocky \
        && if [ $(arch) == x86_64 ]; then     wget -P /tmp  https://github.com/0xERR0R/blocky/releases/download/v$blocky/blocky_$blocky_Linux_x86_64.tar.gz;     tar -xvf /tmp/blocky_$blocky_Linux_x86_64.tar.gz;     mv /blocky_$blocky_Linux_x86_64/blocky /usr/bin/blocky;     chmod +x /usr/bin/blocky;     rm -rf /tmp/blocky_$blocky_Linux_x86_64.tar.gz; fi \
        && if [ $(arch) == aarch64 ]; then    wget -P /tmp  https://github.com/0xERR0R/blocky/releases/download/v$blocky/blocky_$blocky_Linux_arm64.tar.gz;     tar -xvf /tmp/blocky_$blocky_Linux_arm64.tar.gz;     mv /blocky_$blocky_Linux_arm64/blocky /usr/bin/blocky;     chmod +x /usr/bin/blocky;     rm -rf /tmp/blocky_$blocky_Linux_arm64.tar.gz; fi \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /blocky
EXPOSE 53 4000
ENTRYPOINT /entrypoint.sh
