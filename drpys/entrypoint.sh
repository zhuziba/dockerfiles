#!/bin/bash
cd /usr/local/app && pm2 start index.js --name drpys
tail -f /dev/null
