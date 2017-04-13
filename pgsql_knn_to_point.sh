#!/bin/bash

# KNN: K Nearest Neighbors

set +x

TABLE="tmp_portland_streets"
GEOM="POINT(-72.1235 42.3521)"
K="1"


while [[ $# -gt 1 ]]; do
key="$1"
echo "$key"
case $key in
    -t|--table)
        TABLE="$2"
        shift # past argument
    ;;
    -g|--geom)
        GEOM="$2"
        shift # past argument
    ;;
    -k|--k)
        K="$2"
        shift # past argument
    ;;
    -h|--help)
        echo "pgsql_knn_to_point.sh -k INTEGER -g GEOM_WKT -t STRING"
        exit 0
    ;;
    *)
        echo "unknown $key"
        # unknown option
    ;;
esac
shift # past argument or value
done

echo "SELECT
    $TABLE.*,
    ST_Distance(
        $TABLE.geom, ST_GeomFromText('$GEOM')
    ) as distance,
    ST_AsText($TABLE.geom),
    ST_AsGeoJSON($TABLE.geom)
FROM $TABLE
ORDER BY $TABLE.geom <-> ST_GeomFromText('$GEOM')
LIMIT $K;" > tmp.sql

psql -U stefan -d stefan -a -f tmp.sql

rm tmp.sql
