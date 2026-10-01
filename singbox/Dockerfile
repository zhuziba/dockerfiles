FROM golang:1.26-alpine3.23 AS builder
ARG SINGBOX_VERSION=v1.14.2
RUN set -ex \
        && apk add --no-cache git \
        && go install -v -tags with_clash_api,with_v2ray_api,with_dhcp,with_utls,with_quic,with_acme,with_ccm,with_gvisor,with_ocm github.com/sagernet/sing-box/cmd/sing-box@${SINGBOX_VERSION} \
        && cp $(go env GOPATH)/bin/sing-box /usr/bin/ \
        && chmod +x /usr/bin/sing-box

FROM alpine:3.23 AS runtime
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
ENTRYPOINT ["/entrypoint.sh"]
