#!/bin/bash

set -e

# if $MIRROR_URL is set then configure clamav to use it
if [ -n $MIRROR_URL ]; 
then

# remove existing Database mirror lines
sed '/^DatabaseMirror/d' -i /etc/clamav/freshclam.conf
sed "$ a ScriptedUpdates false" -i /etc/clamav/freshclam.conf
sed "$ a DatabaseMirror ${MIRROR_URL}" -i /etc/clamav/freshclam.conf

fi 
