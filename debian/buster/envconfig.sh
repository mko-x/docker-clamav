#!/bin/bash
# update clamd.conf and freshclam.conf from env variables
set -e

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

for OUTPUT in $(env | awk -F "=" '{print $1}' | grep "^CLAMD_CONF_"); do
    test "$OUTPUT" = "CLAMD_CONF_FILE" && continue  # skip configuration file variable

    TRIMMED="${OUTPUT/CLAMD_CONF_/}"
    grep -q "^$TRIMMED " /etc/clamav/clamd.conf && sed "s/^$TRIMMED .*/$TRIMMED ${!OUTPUT}/" -i /etc/clamav/clamd.conf ||
        sed "$ a\\$TRIMMED ${!OUTPUT}" -i /etc/clamav/clamd.conf
done

for OUTPUT in $(env | awk -F "=" '{print $1}' | grep "^FRESHCLAM_CONF_"); do
    test "$OUTPUT" = "FRESHCLAM_CONF_FILE" && continue  # skip configuration file variable

    TRIMMED="${OUTPUT/FRESHCLAM_CONF_/}"
    grep -q "^$TRIMMED " /etc/clamav/freshclam.conf && sed "s/^$TRIMMED .*/$TRIMMED ${!OUTPUT}/" -i /etc/clamav/freshclam.conf ||
        sed "$ a\\$TRIMMED ${!OUTPUT}" -i /etc/clamav/freshclam.conf
done
