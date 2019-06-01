#!/bin/bash

# CRSH - Cloud-based Relay Shell
# Created by Menahi Shayan.
# Allows shell access via interface relay using cloud service.
# Intended to serve as a workaround to ISP port forward blocking.
# Copyright (c) 2019 Menahi Shayan.
# Licensed under the MIT License.

# v0.1

TMP=$DIR/tmp
DIR=/home/shares/public/scripts/crsh
#touch $TMP/crsh.in
#touch $TMP/crsh.out

TIMEOUT=10

while :
do
    if [ $TIMEOUT = 10 ]; then
        PRECHECK=$($DIR/dropbox_uploader.sh list /crsh | grep -y "crsh.in" | sed '/^\s*$/d' | wc -l)
        if [ $PRECHECK = 1 ]; then
            REQUEST=1
        else
            REQUEST=$($DIR/dropbox_uploader.sh monitor /crsh 15 | grep -y "crsh.in" | sed '/^\s*$/d' | wc -l)
        fi
    else
        REQUEST=$($DIR/dropbox_uploader.sh monitor /crsh 30 | grep -y "crsh.in" | sed '/^\s*$/d' | wc -l)
    fi

    if [ $REQUEST = 1 ]; then
        $DIR/dropbox_uploader.sh download /crsh/crsh.in $TMP/crsh.in > /dev/null

        CMD=$(cat $TMP/crsh.in | head -1)

        if [ "$CMD" = "exit" ]; then
            $DIR/dropbox_uploader.sh delete /crsh/crsh.in > /dev/null
            $DIR/dropbox_uploader.sh delete /crsh/crsh.out > /dev/null
            break
        fi

        bash $TMP/crsh.in > $TMP/crsh.out
        $DIR/dropbox_uploader.sh upload $TMP/crsh.out /crsh/crsh.out > /dev/null
        TIMEOUT=0
    elif [ $TIMEOUT = 10 ]; then break;
    else ((TIMEOUT++));
    fi
done
