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
        sqlite3 $STORAGE_FILE_NAME "create table buffer (id INTEGER PRIMARY KEY, inserting_script STRING);"
    fi
}

insert_date() {
    DATE_STRING=$(date "+%Y-%m-%d %H:%M:%S")
    INSERTING_SCRIPT="INSERT INTO buffer (entry, value) VALUES ('date', '"$DATE_STRING"');"

    sqlite3 storage.db "$INSERTING_SCRIPT"
}

create_tables_if_required

# while : ; do
#     insert_date
#     fetch_data | python3 database_data/insert_core_date.py
#     sleep 1
# done
