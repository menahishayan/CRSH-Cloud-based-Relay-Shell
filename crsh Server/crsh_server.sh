#!/bin/bash

# CRSH - Cloud-based Relay Shell
# Created by Menahi Shayan.
# Allows shell access via interface relay using cloud service.
# Intended to serve as a workaround to ISP port forward blocking.
# Copyright (c) 2019 Menahi Shayan.
# Licensed under the MIT License.

# v0.1

TEMP=./tmp/crsh
touch $TMP/crsh.in
touch $TMP/crsh.out

TIMEOUT=10

while :
do
    REQUEST=$(./dropbox_uploader.sh monitor /crsh 60 | grep -y "crsh.in" | wc -l)

    if[ $REQUEST = 1 ]; then
        ./dropbox_uploader.sh download /crsh/crsh.in $TEMP/crsh.in > /dev/null
        bash $TEMP/crsh.in > $TEMP/crsh.out
        ./dropbox_uploader.sh upload $TEMP/crsh.out /crsh/crsh.out > /dev/null
        $TIMEOUT=0
    elif[ $TIMEOUT = 10 ]; then break;
    else ((TIMEOUT++));
    fi
done
