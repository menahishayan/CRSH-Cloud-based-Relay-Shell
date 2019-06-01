#!/bin/bash

# CRSH - Cloud-based Relay Shell
# Created by Menahi Shayan.
# Allows shell access via interface relay using cloud service.
# Intended to serve as a workaround to ISP port forward blocking.
# Copyright (c) 2019 Menahi Shayan.
# Licensed under the MIT License.

# v1.0

TEMPDIR=./tmp
TEMP=$TEMPDIR/crsh
DATE=`date +"%Y-%m-%d"`
#CONFIG=~/.crsh.conf
CONFIG=./crsh.conf
#PWD0=""

IP=`host myip.opendns.com resolver1.opendns.com | grep "has address" | cut -f 4 -d " "`
HOSTNAME=`hostname`

mkdir $TEMP > /dev/null
touch $TEMP/handshake1.crsh

HSEXISTS=$(./dropbox_uploader.sh list /crsh | grep -y "handshake0.crsh" | wc -l)

if [ $HSEXISTS == 1 ]; then
    if [ ! -f $TEMP/token.crsh ]; then
        ./dropbox_uploader.sh download /crsh/handshake0.crsh $TEMP/handshake0.crsh > /dev/null

        chmod 777 $TEMP/handshake0.crsh

        USR0=$(cat $TEMP/handshake0.crsh | tail -2 | head -1)
        PWD0=$(cat $TEMP/handshake0.crsh | tail -1)
        USR1=$(cat $CONFIG | python3 -c "import sys, json; print(json.load(sys.stdin)['username'])")
        PWD1=$(cat $CONFIG | python3 -c "import sys, json; print(json.load(sys.stdin)['password'])")

        if [ "$USR0" = "$USR1" ] && [ "$PWD0" = "$PWD1" ]; then
            TOKEN=$(openssl rand -hex 16)
            echo -e "$DATE\n$IP\n$HOSTNAME\n$USR1\n$TOKEN" > $TEMP/handshake1.crsh
#            echo -e "$TOKEN" >> $TEMP/token.crsh
            ./dropbox_uploader.sh upload $TEMP/handshake1.crsh /crsh/handshake1.crsh > /dev/null

        else
            echo "false" >> $TEMP/handshake1.crsh

            ./dropbox_uploader.sh upload $TEMP/handshake1.crsh /crsh/handshake1.crsh > /dev/null
            rm $TEMP/handshake*.crsh

            ATTEMPT=$(./dropbox_uploader.sh monitor /crsh 60 | grep -y "handshake0.crsh" | wc -l)
        fi


    else
#   session token exists
    fi
else
#    echo "No handshake initiated."
fi



