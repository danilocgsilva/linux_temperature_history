#!/bin/bash

if ! which sqlite3 &> /dev/null; then
    echo The script requires sqlite3
    exit
fi

fetch_data() {
    sensors | sed 1d; grep -i core
}

while : ; do fetch_data; sleep 1; done
