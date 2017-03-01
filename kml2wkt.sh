#!/bin/bash

set +x

# Collect args
KML_FILE="$1"
OUT_FILE=$(echo "$KML_FILE"_$(date '+%s')".csv" | sed "s/.kml//g")

# Run conversion
ogr2ogr -f CSV "$OUT_FILE" "$KML_FILE" -lco GEOMETRY=AS_WKT
