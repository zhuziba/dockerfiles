#!/bin/bash
set -u

nginx -g 'daemon off;' &
NGINX_PID=$!

/usr/bin/ss-server -s 127.0.0.1 -p 9090 -k peng -m chacha20-ietf-poly1305 -t 300 -d 8.8.8.8 -u --plugin v2ray-plugin --plugin-opts "server;path=/peng;loglevel=none" &
SS_PID=$!

_cleanup() {
	kill -TERM "$NGINX_PID" "$SS_PID" 2>/dev/null || true
	wait "$NGINX_PID" 2>/dev/null || true
	wait "$SS_PID" 2>/dev/null || true
}

trap '_cleanup; exit 130' INT
trap '_cleanup; exit 143' TERM

EXIT_STATUS=0
while true; do
	if ! kill -0 "$SS_PID" 2>/dev/null; then
		wait "$SS_PID" || EXIT_STATUS=$?
		break
	fi
	if ! kill -0 "$NGINX_PID" 2>/dev/null; then
		wait "$NGINX_PID" || EXIT_STATUS=$?
		break
	fi
	sleep 1
done

_cleanup
exit "$EXIT_STATUS"
