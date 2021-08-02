#!/bin/bash
# bootstrap clam av service and clam av database updater shell script
# presented by mko (Markus Kosmal<dude@m-ko.de>)
set -m

# Configure freshclam.conf and clamd.conf from env variables if present
source /envconfig.sh

# Start clamd service in background
clamd &

# Based on https://superuser.com/a/917073/66341
# Note `test -S` because clamd.ctl is a socket
wait_file() {
  local file="$1"; shift
  local wait_seconds="${1:-10}"; shift # 10 seconds as default timeout

  echo "Waiting $wait_seconds for $file"

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

# Start the updater in background as daemon
echo "Starting freshclam"
freshclam -d &

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
