#!/bin/bash
# bootstrap clam av service and clam av database updater shell script
# presented by mko (Markus Kosmal<dude@m-ko.de>)
set -m

# configure freshclam.conf and clamd.conf from env variables if present
source /envconfig.sh

if ! [ -z $HTTPProxyServer ]; then echo "HTTPProxyServer $HTTPProxyServer" >> /etc/clamav/freshclam.conf; fi && \
if ! [ -z $HTTPProxyPort   ]; then echo "HTTPProxyPort $HTTPProxyPort" >> /etc/clamav/freshclam.conf; fi && \

DB_DIR=$(sed -n 's/^DatabaseDirectory\s\(.*\)\s*$/\1/p' /etc/clamav/freshclam.conf )
DB_DIR=${DB_DIR:-'/var/lib/clamav'}
MAIN_FILE="$DB_DIR/main.cvd"

DB_DIR=$(sed -n 's/^DatabaseDirectory\s\(.*\)\s*$/\1/p' /etc/clamav/freshclam.conf )
DB_DIR=${DB_DIR:-'/var/lib/clamav'}
MAIN_FILE="$DB_DIR/main.cvd"
echo "[bootstrap] Checking for Clam DB in $MAIN_FILE"

if [ ! -f ${MAIN_FILE} ]; then
    echo "[bootstrap] Initial clam DB download."
    /usr/bin/freshclam
fi

# start clam service itself and the updater in background as daemon
freshclam -d &
clamd &

# recognize PIDs
pidlist=$(jobs -p)

# initialize latest result var
latest_exit=0

# define shutdown helper
function shutdown() {
    trap "" SIGINT

    for single in $pidlist; do
        if ! kill -0 "$single" 2> /dev/null; then
            wait "$single"
            latest_exit=$?
        fi
    done

    kill "$pidlist" 2> /dev/null
}

# run shutdown
trap shutdown SIGINT
wait -n

# return received result
exit $latest_exit
