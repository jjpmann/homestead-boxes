#!/bin/bash

DB=$1
DUMP=$2

LOCK=$LOGS_DIR/.imported-$DB

echo $LOCK

USER=homestead
PW=secret

if [ -e $LOCK ]; then
    echo 'Already imported: ' $DB ' from ' $DUMP;
else
    echo ''
    echo 'IMPORTING DB: ' $DB
    echo '----------'

    if [ ${DUMP: -4} == ".zip" ]; then
        unzip -p $DUMP | mysql -u $USER -p$PW $DB
    else
        mysql -u $USER -p$PW $DB < $DUMP
    fi

    touch $LOCK

fi


