#!/bin/bash

set -eu

MAIN_FILE="/store/main.cvd"

if [ ! -f ${MAIN_FILE} ]; then
    echo "[bootstrap] Initial clam DB download."
    /usr/bin/freshclam
fi

echo "[bootstrap] Schedule freshclam DB updater."
/usr/bin/freshclam -d -c 6

echo "[bootstrap] Run clamav daemon"
exec /usr/sbin/clamd
