FROM alpine
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash git frp supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
	&& chmod +x /entrypoint.sh \
        && mkdir /test \
        && rm -rf /var/cache/apk/*
VOLUME /test
EXPOSE 1080
ENTRYPOINT ["/entrypoint.sh"]
