#!/bin/bash
# update clamd.conf and freshclam.conf from env variables

for OUTPUT in $(env | awk -F "=" '{print $1}' | grep "^CLAMD_CONF_"); do
    TRIMMED="${OUTPUT/CLAMD_CONF_/}"
    grep -q "^$TRIMMED " /etc/clamav/clamd.conf && sed "s/^$TRIMMED .*/$TRIMMED ${!OUTPUT}/" -i /etc/clamav/clamd.conf ||
        sed "$ a\\$TRIMMED ${!OUTPUT}" -i /etc/clamav/clamd.conf
done

for OUTPUT in $(env | awk -F "=" '{print $1}' | grep "^FRESHCLAM_CONF_"); do
    TRIMMED="${OUTPUT/FRESHCLAM_CONF_/}"
    grep -q "^$TRIMMED " /etc/clamav/freshclam.conf && sed "s/^$TRIMMED .*/$TRIMMED ${!OUTPUT}/" -i /etc/clamav/freshclam.conf ||
        sed "$ a\\$TRIMMED ${!OUTPUT}" -i /etc/clamav/freshclam.conf
done
