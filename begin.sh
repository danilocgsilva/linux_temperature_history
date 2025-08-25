#!/bin/bash

if ! which sqlite3 &> /dev/null; then
    echo The script requires sqlite3.
    exit
fi

if ! which python3 &> /dev/null; then
    echo The script requires python in the system.
    exit
fi

DEFAULT_IFS="$IFS"

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

insert_date_into_buffer() {
    DATE_STRING=$(date "+%Y-%m-%d %H:%M:%S")
    sqlite3 storage.db "INSERT INTO buffer (key, value) VALUES ('date_string', '""$DATE_STRING""')"
}

get_core_fetch_results() {
    IFS=$'\n'
    fetch_data | python3 database_data/generate_core_insert.py
    IFS="$DEFAULT_IFS"
}

should_alarm() {
    VALUES=("$@")
    SUM=0

    for i in "${VALUES[@]}"; do
        SUM=$(($SUM + $i))
    done

    MEDIAN=$(($SUM / ${#VALUES[@]}))
    if [ $MEDIAN -gt 50 ]; then
        mpg123 alarm.mp3 > /dev/null 2>&1 &
    fi
}

insert_data() {
    clear_buffer
    insert_date_into_buffer
    
    CORE_INSERTS_RESULTS=("$(get_core_fetch_results)")

    for i in "${CORE_INSERTS_RESULTS[@]}"; do
        sqlite3 storage.db "$i"
    done

    IFS=$'\n'; DATA_FROM_TIME=($(sqlite3 storage.db "SELECT key, value FROM buffer;")); IFS="$DEFAULT_IFS"

    FIELDS=""
    VALUES=""
    OUTPUT_STDOUT=""
    DATA_ARRAY=()
    for i in "${DATA_FROM_TIME[@]}"; do
        FIELD_ITERATION=${i/|*/}
        FIELDS=$FIELDS,$FIELD_ITERATION
        OUTPUT_STDOUT=$OUTPUT_STDOUT$FIELD_ITERATION": "
        
        VALUE_ITERATION=${i/*|/}
        DATA_ARRAY+=("$VALUE_ITERATION")
        VALUES=$VALUES,\'$VALUE_ITERATION\'
        OUTPUT_STDOUT=$OUTPUT_STDOUT$VALUE_ITERATION"\n"
    done
    FIELDS=${FIELDS:1}
    VALUES=${VALUES:1}

    sqlite3 storage.db "INSERT INTO log ($FIELDS) VALUES ($VALUES);"
    echo -e $OUTPUT_STDOUT

    VALUES_ARRAY=("${DATA_ARRAY[@]:1}")

    should_alarm "${VALUES_ARRAY[@]}"
}

clear_buffer() {
    sqlite3 storage.db "DELETE FROM buffer;"
}

create_tables_if_required
clear_buffer

while : ; do
    insert_data &
    sleep 1
done
