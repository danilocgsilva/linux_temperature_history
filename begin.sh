#!/bin/bash

if ! which sqlite3 &> /dev/null; then
    echo The script requires sqlite3.
    exit
fi

if ! which python3 &> /dev/null; then
    echo The script requires python in the system.
    exit
fi

fetch_data() {
    sensors | sed 1d | grep -i core
}

CREATE_TABLE_SCRIPT=$(fetch_data | python3 generate_table_script.py)

STORAGE_FILE_NAME=storage.db
if ! -f $STORAGE_FILE_NAME &> /dev/null; then
    sqlite3 $STORAGE_FILE_NAME "$CREATE_TABLE_SCRIPT"
fi


