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

create_tables_if_required() {
    STORAGE_FILE_NAME=storage.db
    if ! [ -f $STORAGE_FILE_NAME ]; then
        CREATE_TABLE_SCRIPT=$(fetch_data | python3 database_data/generate_table_script.py)
        sqlite3 $STORAGE_FILE_NAME "$CREATE_TABLE_SCRIPT"
        sqlite3 $STORAGE_FILE_NAME "create table buffer (id INTEGER PRIMARY KEY, key STRING, value STRING);"
    fi
}

insert_date() {
    DATE_STRING=$(date "+%Y-%m-%d %H:%M:%S")
    sqlite3 storage.db "INSERT INTO buffer (key, value) VALUES ('date', '""$DATE_STRING""')"
}

insert_data() {
    insert_date
    DEFAULT_IFS="$IFS"
    IFS=$'\n'
    CORE_INSERTS_RESULTS=($(fetch_data | python3 database_data/generate_core_insert.py))
    IFS="$DEFAULT_IFS"

    for i in "${CORE_INSERTS_RESULTS[@]}"
    do
        sqlite3 storage.db "$i"
    done
}

clear_buffer() {
    sqlite3 storage.db "DELETE FROM buffer;"
}

create_tables_if_required
clear_buffer
insert_data
# while : ; do
#     insert_date
#     fetch_data | python3 database_data/insert_core_date.py
#     sleep 1
# done
