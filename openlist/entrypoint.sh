#!/bin/bash
if [ "$1" = "version" ]; then
  exec /usr/bin/openlist version
else
  exec /usr/bin/openlist server --no-prefix
fi
