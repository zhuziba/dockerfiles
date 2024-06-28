#!/bin/bash
if [ "$1" = "version" ]; then
  /usr/bin/alist version
else
  /usr/bin/alist server --no-prefix
fi
