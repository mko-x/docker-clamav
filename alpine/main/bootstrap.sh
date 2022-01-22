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

# if /var/lib/clamav/ doesn't have the virus database..
if [ ! -f "$MAIN_FILE" ] && [ -f /var/lib/clamav.source/main.cvd ]; then
  # ..initialize it using the database we shipped in the docker image
  cp /var/lib/clamav.source/*.cvd "$DB_DIR"
fi

function clam_start () {
    if [[ ! -e /var/run/clamav/created ]]
    then
        touch /var/run/clamav/created
    fi
    freshclam -d &
    echo -e "waiting for clam to update..."
    until [[ -e ${MAIN_FILE} ]]
    do
        :
    done
    echo -e "starting clamd..."
    clamd &
}

if [[ ! -z "${CLAM_DELAY}" ]]
then
    if [[ ! -z "${DELAY_CREATE_ONLY}" && -e /var/run/clamav/created ]]
    then
        clam_start
    else
        echo -e "waiting for ${CLAM_DELAY} before starting clamav..."
        sleep ${CLAM_DELAY} && clam_start
    fi
else
    clam_start
fi

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
