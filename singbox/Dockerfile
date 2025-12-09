FROM alpine:3.22 AS builder
RUN set -ex \
        && apk add git curl go sing-box \
        #&& go install -v -tags with_clash_api,with_ech,with_utls,with_quic,with_acme github.com/sagernet/sing-box/cmd/sing-box@main \
        #&& cp $(go env GOPATH)/bin/sing-box /usr/bin/ \
        && chmod +x /usr/bin/sing-box

FROM alpine:3.22 AS runtime
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /usr/bin/sing-box /usr/bin/sing-box
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
	&& chmod +x /entrypoint.sh \
        && mkdir /singbox \
	&& wget -O /geosite.db https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db \
        && wget -O /geoip.db https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db \
        && rm -rf /var/cache/apk/*
VOLUME /singbox
EXPOSE 443
ENTRYPOINT ["/entrypoint.sh"]
