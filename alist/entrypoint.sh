#!/bin/bash
if [ "$1" = "version" ]; then
  /usr/bin/openlist version
else
  /usr/bin/openlist server --no-prefix
fi
