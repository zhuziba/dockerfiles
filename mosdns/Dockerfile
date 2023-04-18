FROM alpine as builder

WORKDIR /usr/src
RUN apk update -f && apk upgrade
RUN apk add git go

RUN git clone https://github.com/IrineSistiana/mosdns.git /usr/src/mosdns && cd /usr/src/mosdns && go build -o /usr/src/mosdns/mosdns
RUN git clone https://github.com/AdguardTeam/dnsproxy.git /usr/src/dnsproxy && cd /usr/src/dnsproxy && go build -mod=vendor -o /usr/src/dnsproxy/dnsproxy

# Set the working directory
WORKDIR /usr/src/mosdns
WORKDIR /usr/src/dnsproxy

FROM alpine
COPY --from=builder /usr/src/mosdns/mosdns /usr/bin/mosdns
COPY --from=builder /usr/src/dnsproxy/dnsproxy /usr/bin/dnsproxy
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget bash frp redis python3 py3-pip \
        && pip3 install supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /rules \ 
        && wget -O /rules/gfw.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/gfw.txt \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/accelerated-domains.china.conf \
        && wget -O /rules/CN-ip-cidr.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/CN-ip-cidr.txt \
        && echo '0 2 * * *  wget -O /rules/gfw.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/gfw.txt'>>/var/spool/cron/crontabs/root  \
        && echo '5 2 * * *  wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/accelerated-domains.china.conf'>>/var/spool/cron/crontabs/root  \
        && echo '10 2 * * *  wget -O /rules/CN-ip-cidr.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/CN-ip-cidr.txt'>>/var/spool/cron/crontabs/root  \
        && mkdir /mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /usr/bin/frps \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 53
ENTRYPOINT /entrypoint.sh
