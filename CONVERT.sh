#!/bin/bash
set +x

CSV_FILE="$1"
LONGITUDE="$2"
LATITUDE="$3"

tmp_vrt='<OGRVRTDataSource>
    <OGRVRTLayer name="test">
        <SrcDataSource>test.csv</SrcDataSource>
    <SrcLayer>TEST</SrcLayer>
    <GeometryType>wkbPoint</GeometryType>
        <LayerSRS>WGS84</LayerSRS>
    <GeometryField encoding="PointFromColumns" x="'$LONGITUDE'" y="'$LATITUDE'"/>
    </OGRVRTLayer>
</OGRVRTDataSource>'

echo "$tmp_vrt" > _tmp.vrt


OUT_FILE=$(echo "$CSV_FILE"_$(date '+%s')".shp" | sed "s/.csv//g")

echo "$OUT_FILE"

ogr2ogr -f "ESRI Shapefile" "$OUT_FILE" "_tmp.vrt"

rm "_tmp.vrt"


# ogr2ogr -f CSV output.csv example.shp -lco GEOMETRY=AS_WKT