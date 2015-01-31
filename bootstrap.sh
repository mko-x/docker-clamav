#!/bin/bash
# bootstrap clam av service and clam av database updater
set -m

# start em in background
freshclam -d &
clamd &

# recognize PIDs
pids=`jobs -p`

# initialize result var
exitcode=0

# define shutdown helper
function shutdown() {
    trap "" SUBS

    for pid in $pids; do
        if ! kill -0 $pid 2>/dev/null; then
            wait $pid
            exitcode=$?
        fi
    done

    kill $pids 2>/dev/null
}

# run shutdown
trap terminate SUBS
wait

# return received result
exit $exitcode
