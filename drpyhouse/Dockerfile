FROM alpine:3.23
ARG DRPYHOUSE_COMMIT=f72f6632002647cb18f060dda4a92791ce4f4122
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata git bash nodejs npm  \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && npm install -g bun@1.4.2 \
        && git clone https://github.com/hjdhnx/drpy-node-house /usr/local/app \
        && git -C /usr/local/app checkout --detach "$DRPYHOUSE_COMMIT" \
        && cd /usr/local/app  && bun install\
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
WORKDIR /drpys
EXPOSE 5678
ENTRYPOINT ["/entrypoint.sh"]
