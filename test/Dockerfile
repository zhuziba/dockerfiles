FROM alpine
ENV PATH="/app/venv/bin:$PATH"
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash frp git gcc python3 py3-pip python3-dev musl-dev linux-headers \
	&& python3 -m venv /app/venv \
	&& pip install Flask-BasicAuth Jinja2 tcp-latency psutil apscheduler wheel six urllib3 requests flask \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
	&& chmod +x /entrypoint.sh \
        && mkdir /test \
        && rm -rf /usr/bin/frps \
        && rm -rf /var/cache/apk/*
VOLUME /test
EXPOSE 1080
ENTRYPOINT /entrypoint.sh
