#!/bin/bash

if ! which sqlite3 &> /dev/null; then
    echo The script requires sqlite3.
    exit
fi

if ! which python3 &> /dev/null; then
    echo The script requires python in the system.
    exit
fi

if ! which mpg123 &> /dev/null; then
    echo The script requires mpg123 to alarm.
    exit
fi

DEFAULT_IFS="$IFS"

source ./functions.sh

create_tables_if_required
clear_buffer

while : ; do
    insert_data &
    sleep 1
done
