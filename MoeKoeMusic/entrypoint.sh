#!/bin/bash
# 开启转发
cd /app/api && node app.js & nginx -g 'daemon off;'
tail -f /dev/null