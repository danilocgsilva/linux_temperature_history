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
    sqlite3 storage.db "INSERT INTO buffer (key, value) VALUES ('date_string', '""$DATE_STRING""')"
}

insert_data() {
    clear_buffer
    insert_date
    DEFAULT_IFS="$IFS"
    IFS=$'\n'
    CORE_INSERTS_RESULTS=($(fetch_data | python3 database_data/generate_core_insert.py))
    IFS="$DEFAULT_IFS"

    for i in "${CORE_INSERTS_RESULTS[@]}"
    do
        sqlite3 storage.db "$i"
    done

    IFS=$'\n'
    DATA_FROM_TIME=($(sqlite3 storage.db "SELECT key, value FROM buffer;"))
    IFS="$DEFAULT_IFS"

    FIELDS=""
    VALUES=""
    for i in "${DATA_FROM_TIME[@]}"
    do
        FIELD_ITERATION=$(echo $i | cut -f1 -d'|')
        FIELDS=$FIELDS,$FIELD_ITERATION
        
        VALUE_ITERATION=$(echo $i | cut -f2 -d'|')
        VALUES=$VALUES,\'$VALUE_ITERATION\'
    done
    FIELDS=$(echo $FIELDS | cut -c2-)
    VALUES=$(echo $VALUES | cut -c2-)

    sqlite3 storage.db "INSERT INTO log ($FIELDS) VALUES ($VALUES);"
}

clear_buffer() {
    sqlite3 storage.db "DELETE FROM buffer;"
}

create_tables_if_required
clear_buffer

while : ; do
    insert_data
    sleep 1
done
