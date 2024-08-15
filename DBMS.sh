#!/bin/bash

# Define usage function
usage() {
    echo "Usage: $0 {create_db|create_table|insert|query|delete_table|delete_db} [options]"
    echo "Commands:"
    echo "  create_db <db_name>       - Create a new database"
    echo "  create_table <db_name> <table_name> - Create a new table in a database"
    echo "  insert <db_name> <table_name> <data> - Insert data into a table"
    echo "  query <db_name> <table_name> - Query data from a table"
    echo "  delete_table <db_name> <table_name> - Delete a table"
    echo "  delete_db <db_name>       - Delete a database"
    exit 1
}

# Create a new database
create_db() {
    local db_name="$1"
    if [ ! -d "$db_name" ]; then
        mkdir "$db_name"
        echo "Database '$db_name' created."
    else
        echo "Database '$db_name' already exists."
    fi
}

# Create a new table in a database
create_table() {
    local db_name="$1"
    local table_name="$2"
    if [ -d "$db_name" ]; then
        if [ ! -f "$db_name/$table_name" ]; then
            touch "$db_name/$table_name"
            echo "Table '$table_name' created in database '$db_name'."
        else
            echo "Table '$table_name' already exists."
        fi
    else
        echo "Database '$db_name' does not exist."
    fi
}

# Insert data into a table
insert() {
    local db_name="$1"
    local table_name="$2"
    local data="$3"
    if [ -f "$db_name/$table_name" ]; then
        echo "$data" >> "$db_name/$table_name"
        echo "Data inserted into table '$table_name'."
    else
        echo "Table '$table_name' does not exist in database '$db_name'."
    fi
}

# Query data from a table
query() {
    local db_name="$1"
    local table_name="$2"
    if [ -f "$db_name/$table_name" ]; then
        cat "$db_name/$table_name"
    else
        echo "Table '$table_name' does not exist in database '$db_name'."
    fi
}

# Delete a table
delete_table() {
    local db_name="$1"
    local table_name="$2"
    if [ -f "$db_name/$table_name" ]; then
        rm "$db_name/$table_name"
        echo "Table '$table_name' deleted from database '$db_name'."
    else
        echo "Table '$table_name' does not exist in database '$db_name'."
    fi
}

# Delete a database
delete_db() {
    local db_name="$1"
    if [ -d "$db_name" ]; then
        rm -r "$db_name"
        echo "Database '$db_name' deleted."
    else
        echo "Database '$db_name' does not exist."
    fi
}

# Check for sufficient arguments
if [ $# -lt 1 ]; then
    usage
fi

# Parse command
command="$1"
shift

case "$command" in
    create_db)
        if [ $# -ne 1 ]; then usage; fi
        create_db "$1"
        ;;
    create_table)
        if [ $# -ne 2 ]; then usage; fi
        create_table "$1" "$2"
        ;;
    insert)
        if [ $# -ne 3 ]; then usage; fi
        insert "$1" "$2" "$3"
        ;;
    query)
        if [ $# -ne 2 ]; then usage; fi
        query "$1" "$2"
        ;;
    delete_table)
        if [ $# -ne 2 ]; then usage; fi
        delete_table "$1" "$2"
        ;;
    delete_db)
        if [ $# -ne 1 ]; then usage; fi
        delete_db "$1"
        ;;
    *)
        usage
        ;;
esac
