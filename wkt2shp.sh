#!/bin/bash

set +x

# Collect args
CSV_FILE="$1"
FIELD="$2"
DATASOURCE_NAME=$(echo "$CSV_FILE" | sed "s/.csv//g")

# Create VRT file
tmp_vrt='<OGRVRTDataSource>
    <OGRVRTLayer name="'$DATASOURCE_NAME'">
        <SrcDataSource>'$CSV_FILE'</SrcDataSource>
    <SrcLayer>'$DATASOURCE_NAME'</SrcLayer>
    <GeometryType>wkbPoint</GeometryType>
        <LayerSRS>WGS84</LayerSRS>
    <GeometryField encoding="WKT" field="'$FIELD'"/>
    </OGRVRTLayer>
</OGRVRTDataSource>'

echo "$tmp_vrt" > _tmp.vrt

# Create outfile name
OUT_FILE=$(echo "$CSV_FILE"_$(date '+%s')".shp" | sed "s/.csv//g")
#echo "$OUT_FILE"

# Run csv to shp conversion
ogr2ogr -f "ESRI Shapefile" "$OUT_FILE" "_tmp.vrt"

# Clean temp files
rm "_tmp.vrt"


# ogr2ogr -f CSV output.csv example.shp -lco GEOMETRY=AS_WKT
#ogr2ogr -f "ESRI Shapefile" example.shp example.vrt
