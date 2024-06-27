#!/bin/bash

chown -R ${PUID}:${PGID} /opt/alist/

umask ${UMASK}

if [ "$1" = "version" ]; then
  /usr/bin/alist version
else
  exec su-exec ${PUID}:${PGID} /usr/bin/alist server --no-prefix
fi
