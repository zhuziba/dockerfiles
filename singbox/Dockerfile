FROM alpine:edge as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add git curl go \
        && go install -v -tags with_ech,with_utls,with_acme github.com/sagernet/sing-box/cmd/sing-box@main \
        && cp $(go env GOPATH)/bin/sing-box /usr/bin/ \
        && chmod +x /usr/bin/sing-box

FROM alpine as runtime
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /usr/bin/sing-box /usr/bin/sing-box
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
	&& chmod +x /entrypoint.sh \
        && mkdir /singbox \
        && rm -rf /var/cache/apk/*
VOLUME /singbox
EXPOSE 443
ENTRYPOINT /entrypoint.sh
