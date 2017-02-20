#!/bin/bash

IN_FILE="$1"

#OUT_FILE=$(echo "$IN_FILE"_$(date '+%d/%m/%Y_%H:%M:%S')".geojson" | sed "s/.shp//g")
OUT_FILE=$(echo "$IN_FILE"_$(date '+%F')".geojson" | sed "s/.shp//g")

echo "$OUT_FILE"
ogr2ogr -f GeoJSON "$OUT_FILE" "$IN_FILE"


