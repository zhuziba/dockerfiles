FROM alpine
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /blocky \
        && if [ $(arch) == x86_64 ]; then     wget -P /tmp  https://github.com/0xERR0R/blocky/releases/download/v0.20/blocky_0.20_Linux_x86_64.tar.gz;     tar -xvf /tmp/blocky_0.20_Linux_x86_64.tar.gz -C /tmp;     mv /tmp/blocky /usr/bin/blocky;     chmod +x /usr/bin/blocky;     rm -rf /tmp/blocky_0.20_Linux_x86_64.tar.gz;     mkdir /lib64;      ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2; fi \
        && if [ $(arch) == aarch64 ]; then    wget -P /tmp  https://github.com/0xERR0R/blocky/releases/download/v0.20/blocky_0.20_Linux_arm64.tar.gz;     tar -xvf /tmp/blocky_0.20_Linux_arm64.tar.gz -C /tmp;     mv /tmp/blocky /usr/bin/blocky;     chmod +x /usr/bin/blocky;     rm -rf /tmp/blocky_0.20_Linux_arm64.tar.gz; fi \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /blocky
EXPOSE 53 4000
ENTRYPOINT /entrypoint.sh
