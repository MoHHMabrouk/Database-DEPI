#!/bin/bash

# Check if dialog is installed
if ! command -v dialog &> /dev/null
then
    echo "Dialog is not installed. Please install it using 'sudo apt-get install dialog' (on Debian/Ubuntu) or 'sudo yum install dialog' (on CentOS/RHEL)."
    exit 1
fi

# Function to create a new database
create_db() {
    db_name=$(dialog --inputbox "Enter database name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    mkdir -p "$db_name" && dialog --msgbox "Database '$db_name' created successfully!" 6 40
}

# Function to create a new table
create_table() {
    db_name=$(dialog --inputbox "Enter database name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    if [ ! -d "$db_name" ]; then
        dialog --msgbox "Database '$db_name' does not exist!" 6 40
        return
    fi
    table_name=$(dialog --inputbox "Enter table name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    if [ -f "$db_name/$table_name" ]; then
        dialog --msgbox "Table '$table_name' already exists in database '$db_name'!" 6 40
        return
    fi
    columns=$(dialog --inputbox "Enter column names (comma separated):" 8 40 3>&1 1>&2 2>&3 3>&-)
    echo "$columns" > "$db_name/$table_name" && dialog --msgbox "Table '$table_name' created with columns: $columns" 6 60
}

# Function to insert data into a table
insert() {
    db_name=$(dialog --inputbox "Enter database name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    if [ ! -d "$db_name" ]; then
        dialog --msgbox "Database '$db_name' does not exist!" 6 40
        return
    fi
    table_name=$(dialog --inputbox "Enter table name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    if [ ! -f "$db_name/$table_name" ]; then
        dialog --msgbox "Table '$table_name' does not exist in database '$db_name'!" 6 40
        return
    fi
    columns=$(head -n 1 "$db_name/$table_name")
    data=$(dialog --inputbox "Enter data for columns ($columns):" 8 60 3>&1 1>&2 2>&3 3>&-)
    echo "$data" >> "$db_name/$table_name" && dialog --msgbox "Data inserted into table '$table_name'!" 6 40
}

# Function to query data from a table
query() {
    db_name=$(dialog --inputbox "Enter database name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    if [ ! -d "$db_name" ]; then
        dialog --msgbox "Database '$db_name' does not exist!" 6 40
        return
    fi
    table_name=$(dialog --inputbox "Enter table name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    if [ ! -f "$db_name/$table_name" ]; then
        dialog --msgbox "Table '$table_name' does not exist in database '$db_name'!" 6 40
        return
    fi
    data=$(column -t -s ',' "$db_name/$table_name")
    dialog --msgbox "Data in table '$table_name':\n\n$data" 20 80
}

# Function to delete a table
delete_table() {
    db_name=$(dialog --inputbox "Enter database name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    if [ ! -d "$db_name" ]; then
        dialog --msgbox "Database '$db_name' does not exist!" 6 40
        return
    fi
    table_name=$(dialog --inputbox "Enter table name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    if [ ! -f "$db_name/$table_name" ]; then
        dialog --msgbox "Table '$table_name' does not exist in database '$db_name'!" 6 40
        return
    fi
    rm "$db_name/$table_name" && dialog --msgbox "Table '$table_name' deleted from database '$db_name'!" 6 40
}

# Function to delete a database
delete_db() {
    db_name=$(dialog --inputbox "Enter database name:" 8 40 3>&1 1>&2 2>&3 3>&-)
    if [ ! -d "$db_name" ]; then
        dialog --msgbox "Database '$db_name' does not exist!" 6 40
        return
    fi
    rm -r "$db_name" && dialog --msgbox "Database '$db_name' deleted!" 6 40
}

# Main loop
while true; do
    choice=$(dialog --clear --backtitle "Simple DBMS in Bash" \
        --title "Main Menu" \
        --menu "Choose an option:" 15 50 6 \
        1 "Create Database" \
        2 "Create Table" \
        3 "Insert Data" \
        4 "Query Data" \
        5 "Delete Table" \
        6 "Delete Database" \
        7 "Exit" 3>&1 1>&2 2>&3 3>&-)

    case $choice in
        1) create_db ;;
        2) create_table ;;
        3) insert ;;
        4) query ;;
        5) delete_table ;;
        6) delete_db ;;
        7) break ;;
        *) break ;;
    esac
done

clear
