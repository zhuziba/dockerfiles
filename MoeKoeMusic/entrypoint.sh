#!/bin/sh
# Start API and nginx, forward signals and exit when either process stops
set -e
cd /app/api || exit 1

# start node API in background
node app.js &
NODE_PID=$!

# start nginx
nginx -g 'daemon off;' &
NGINX_PID=$!

_cleanup() {
	kill -TERM "$NODE_PID" 2>/dev/null || true
	kill -TERM "$NGINX_PID" 2>/dev/null || true
	wait "$NODE_PID" 2>/dev/null || true
	wait "$NGINX_PID" 2>/dev/null || true
}

trap '_cleanup; exit 0' INT TERM

# wait until either process exits
while true; do
	if ! kill -0 "$NODE_PID" 2>/dev/null || ! kill -0 "$NGINX_PID" 2>/dev/null; then
		break
	fi
	sleep 1
done

_cleanup
exit 0