FROM alpine
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash frp git python3 py3-pip py3-flask py3-requests py3-urllib3 py3-six py3-wheel py3-psutil py3-apscheduler \
	&& pip install Flask-BasicAuth Jinja2 tcp-latency \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
	&& chmod +x /entrypoint.sh \
        && mkdir /test \
        && rm -rf /usr/bin/frps \
        && rm -rf /var/cache/apk/*
VOLUME /test
EXPOSE 1080
ENTRYPOINT /entrypoint.sh
