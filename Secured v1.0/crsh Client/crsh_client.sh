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
CONFIG=~/.crsh.conf
ITERATOR = $1

if [ "$ITERATOR" = "" ]; then
    $ITERATOR=1
elif [ "$ITERATOR" = "3" ]; then
    echo "3 incorrect password attempts."
    exit
fi

mkdir $TEMP 2>&1 /dev/null
touch $TEMP/handshake0.crsh

IP=`host myip.opendns.com resolver1.opendns.com | grep "has address" | cut -f 4 -d " "`

# if [ -f $CONFIG ]; then


read -p 'Username: ' USRNAME
read -sp 'Password: ' PASS
echo

MASKED=$(printf '%s' $PASS | md5)
HOSTNAME=`hostname`

echo -e "$DATE\n$IP\n$HOSTNAME\n$USRNAME\n$MASKED" > $TEMP/handshake0.crsh

#cat $TEMP/handshake0.crsh

./dropbox_uploader.sh upload $TEMP/handshake0.crsh /crsh/handshake0.crsh 2>&1 /dev/null

REPLIED=$(./dropbox_uploader.sh monitor /crsh 100 | grep -y "handshake1.crsh" | wc -l)

if [ "$REPLIED" == 1 ]; then
    ./dropbox_uploader.sh download /crsh/handshake1.crsh $TEMP/handshake1.crsh 2>&1 /dev/null

#./dropbox_uploader.sh delete /crsh/handshake0.crsh 2>&1 /dev/null

#./dropbox_uploader.sh delete /crsh/handshake1.crsh 2>&1 /dev/null

    REPLY=$(cat $TEMP/handshake1.crsh | tail -1)
    if [ "$REPLY" != "false" ]; then
        echo -e "$REPLY" > $TEMP/token.crsh
        PROMPT="$(cat $TEMP/handshake1.crsh | tail -2 | head -1)@$(cat $TEMP/handshake1.crsh | tail -3 | head -1)"
        echo -e "$PROMPT"
    else
        echo "Incorrect Username or Password."
        ./crsh_client.sh $(($ITERATOR+1))
    fi
else
    echo "Server unreachable. Please check the network and try again."
fi
