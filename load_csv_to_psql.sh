#!/bin/bash
#set -x

CSV_FILE="$1"
TMP_TABLE="$2"

#echo "$CSV_FILE $TMP_TABLE"

# Clean up database tables
psql -c "TRUNCATE $TMP_TABLE"
psql -c "DROP TABLE $TMP_TABLE"

# Get and clean file header string
HEADER=$(head -1 $CSV_FILE)
HEADER=$(echo "$HEADER" | sed -e 's/\r//g' | sed -e 's/\n//g')

# Create psql table
COLS=$(echo "$HEADER"| sed -e 's/,/ TEXT,/g' | sed -e 's/"//g')
CREATE_TABLE="CREATE TABLE IF NOT EXISTS ${TMP_TABLE} (${COLS} TEXT)"
CREATE_TABLE=$(echo "$CREATE_TABLE" | sed -e 's/\./_/g')
#echo "$CREATE_TABLE"
psql -c "$CREATE_TABLE"

FILEHEADER=$(head -1 $CSV_FILE)
FILEHEADER=$(echo "$FILEHEADER" | sed -e 's/\r//g' | sed -e 's/\n//g' | sed  -e 's/"//g')
#echo "\copy ${TMP_TABLE}(${FILEHEADER}) FROM '$CSV_FILE' WITH CSV HEADER NULL AS ''"
psql -c "\copy ${TMP_TABLE}(${FILEHEADER}) FROM '$CSV_FILE' WITH CSV HEADER NULL AS ''"

#echo "$FILEHEADER"