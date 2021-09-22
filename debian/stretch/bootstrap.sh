#!/bin/bash
# bootstrap clam av service and clam av database updater shell script
# presented by mko (Markus Kosmal<dude@m-ko.de>)
set -m  # job control

source /custom-bootstrap.sh

if [[ ! -z "${FRESHCLAM_CONF_FILE}" ]]; then
    echo "[bootstrap] FRESHCLAM_CONF_FILE set, copy to /etc/clamav/freshclam.conf"
    mv /etc/clamav/freshclam.conf /etc/clamav/freshclam.conf.bak
    cp -f ${FRESHCLAM_CONF_FILE} /etc/clamav/freshclam.conf
fi

if [[ ! -z "${CLAMD_CONF_FILE}" ]]; then
    echo "[bootstrap] CLAMD_CONF_FILE set, copy to /etc/clamav/clamd.conf"
    mv /etc/clamav/clamd.conf /etc/clamav/clamd.conf.bak
    cp -f ${CLAMD_CONF_FILE} /etc/clamav/clamd.conf
fi

# Check if this is a first time run
# The virus definition database is stored in ``/var/lib/clamav``.
# Use ``-v clamdb:/var/lib/clamav`` option with docker run command
# to persist and avoid download of db every time we start the daemon.
if [ -z "$(ls -A /var/lib/clamav)" ]; then
    # Run freshclam in foreground to avoid container exiting
    # while we get fresh defs.
    echo "No ClamAV database - running freshclam for first time"
    freshclam
else
    echo "ClamAV database found!"
fi

# Start clamd service in background
echo "Starting clamd in background"
clamd &

# Based on https://superuser.com/a/917073/66341
# Note `test -S` because clamd.ctl is a socket
wait_file() {
  local file="$1"; shift
  local wait_seconds="${1:-10}"; shift # 10 seconds as default timeout

  echo "Waiting $wait_seconds seconds for $file"

  until test $((wait_seconds--)) -eq 0 -o -S "$file" ; 
  do
    sleep 1
  done
  
  ((++wait_seconds))
}

LOCKFILE=/var/run/clamav/clamd.ctl
wait_file "$LOCKFILE" 60 || {
    >&2 echo "$LOCKFILE not found after waiting for 60 seconds. There may be issues with updating virus defs"
}

# Clamd should be up, start the updater in background as daemon
echo "Starting freshclam in background"
freshclam -d &

# recognize PIDs
pidlist=`jobs -p`

# initialize latest result var
latest_exit=0

# define shutdown helper
function shutdown() {
    trap "" SIGINT

    for single in $pidlist; do
        if ! kill -0 $single 2>/dev/null; then
            wait $single
            latest_exit=$?
        fi
    done

    kill $pidlist 2>/dev/null
}

# run shutdown
trap shutdown SIGINT
wait -n

# return received result
exit $latest_exit
