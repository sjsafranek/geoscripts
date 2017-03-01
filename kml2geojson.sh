#!/bin/bash

set +x

# Collect args
KML_FILE="$1"
OUT_FILE=$(echo "$KML_FILE"_$(date '+%s')".geojson" | sed "s/.kml//g")

# Run conversion
ogr2ogr -f GeoJSON "$OUT_FILE" "$KML_FILE"
