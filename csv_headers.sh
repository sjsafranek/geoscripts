#!/bin/bash

set +x

# Collect args
CSV_FILE="$1"

# Get file header
HEADER=$(head -1 $CSV_FILE)
# Clean file header string
HEADER=$(echo "$HEADER" | sed -e 's/\r//g' | sed -e 's/\n//g')
# Split file header string by csv delimiter
HEAD=$(echo $HEADER | tr "," "\n")
# Headers array
HEADERS=()

# Add new fields to headers
for field in $HEAD
do
	HEADERS+=("$field")
	echo "$field"
done

