#!/bin/bash

# CRSH - Cloud-based Relay Shell
# Created by Menahi Shayan.
# Allows shell access via interface relay using cloud service.
# Intended to serve as a workaround to ISP port forward blocking.
# Copyright (c) 2019 Menahi Shayan.
# Licensed under the MIT License.

# v0.1

TMP=./tmp
#touch $TMP/crsh.in

FIRST=1

while true
do
    if [ $FIRST = 1 ]; then
        FIRST=0
        PRECHECK=$(./dropbox_uploader.sh list /crsh | grep -y "crsh.out" | sed '/^\s*$/d' | wc -l)
        if [ $PRECHECK = 1 ]; then
            ./dropbox_uploader.sh download /crsh/crsh.out $TMP/crsh.out > /dev/null
            FILESIZE=$(du -k $TMP/crsh.out | cut -f1 )
            if [ $FILESIZE -le 1000 ]; then
                cat $TMP/crsh.out
            else echo "Output saved in crsh.out"
            fi

            ./dropbox_uploader.sh delete /crsh/crsh.in > /dev/null
            ./dropbox_uploader.sh delete /crsh/crsh.out > /dev/null
        fi
    fi
    read -p 'root@GoFlexHome:~# ' CMD

    if [ ${#CMD} -le 1 ]; then
    continue
    fi

    echo "$CMD" > "$TMP/crsh.in"
    ./dropbox_uploader.sh upload $TMP/crsh.in /crsh/crsh.in > /dev/null

    if [ "$CMD" = "exit" ]; then
        break
    fi

    FLAG=0

    for i in {1..10}
    do
        RESULT=$(./dropbox_uploader.sh monitor /crsh 30 | grep -y "crsh.out" | sed '/^\s*$/d' | wc -l)

    if [ $RESULT = 1 ]; then
            ./dropbox_uploader.sh download /crsh/crsh.out $TMP/crsh.out > /dev/null
            FILESIZE=$(du -k $TMP/crsh.out | cut -f1 )
            if [ $FILESIZE -le 1000 ]; then
                cat $TMP/crsh.out
            else echo "Output saved in crsh.out"
            fi
            FLAG=1
            break
        fi
    done

if [ $FLAG = 0 ]; then echo "I/O Error"; break; fi
done
