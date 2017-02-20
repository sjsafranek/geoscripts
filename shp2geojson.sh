#!/bin/bash

set +x

# Collect args
SHP_FILE="$1"
OUT_FILE=$(echo "$CSV_FILE"_$(date '+%s')".geojson" | sed "s/.shp//g")

# Run conversion
ogr2ogr -f GeoJSON "$OUT_FILE" "$SHP_FILE"
