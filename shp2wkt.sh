#!/bin/bash

set +x

# Collect args
SHP_FILE="$1"
OUT_FILE=$(echo "$SHP_FILE"_$(date '+%s')".csv" | sed "s/.shp//g")

# Run conversion
ogr2ogr -f CSV "$OUT_FILE" "$SHP_FILE" -lco GEOMETRY=AS_WKT
