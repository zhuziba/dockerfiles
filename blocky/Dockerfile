FROM alpine as builder

WORKDIR /usr/src
RUN apk update -f && apk upgrade
RUN apk add git go upx

RUN git clone https://github.com/0xERR0R/blocky.git /usr/src/blocky && cd /usr/src/blocky && go build -o /usr/src/blocky/blocky

#压缩文件
RUN upx /usr/src/blocky/blocky

WORKDIR /usr/src/blocky

FROM alpine
COPY --from=builder /usr/src/blocky/blocky /usr/bin/blocky
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata curl bash \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /blocky \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /blocky
EXPOSE 53 4000
ENTRYPOINT /entrypoint.sh
