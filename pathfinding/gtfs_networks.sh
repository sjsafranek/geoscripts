#!/bin/bash
set -x

# DEBUGGING
# rm tmp/*
rm tmp/agency.txt
rm tmp/calendar.txt
rm tmp/calendar_dates.txt
rm tmp/routes.txt
rm tmp/shapes.txt
rm tmp/stops.txt
rm tmp/stop_times.txt
rm tmp/trips.txt
rm tmp/transfers.txt
rm tmp/tmp_routes.csv

# psql -c "DROP TABLE routes_networks";
# psql -c "DROP TABLE shapes_networks";
# psql -c "DROP TABLE trips_networks";
psql -c "TRUNCATE routes_networks";
psql -c "TRUNCATE shapes_networks";
psql -c "TRUNCATE trips_networks";

# Unpack gtfs zip archive to tmp directoryA
ARCHIVE="$1"
unzip $ARCHIVE -d tmp

# Get agency name
AGENCY_ID=$(python3 agency_id.py)
AGENCY_NAME=$(python3 agency_name.py)
CUSTOMER_ID=$(echo "$AGENCY_NAME" | sed -e 's/ /_/g')

# Create database tables
psql -f create_tables_networks.sql

# Upload gtfs files to database
TRIP_COLS=$(head -1 tmp/trips.txt)
ROUTES_COLS=$(head -1 tmp/routes.txt)
SHAPES_COLS=$(head -1 tmp/shapes.txt)

COLS=$(echo "$TRIP_COLS" | sed -e 's/,/ TEXT,/g' | sed -e 's/\r//g' | sed -e 's/\n//g')
CREATE_TABLE_TMP_TRIPS="CREATE TABLE IF NOT EXISTS tmp_trips (${COLS} TEXT);"
psql -c "$CREATE_TABLE_TMP_TRIPS"
psql -c "\copy tmp_trips($TRIP_COLS) FROM 'tmp/trips.txt' WITH CSV HEADER NULL AS ''"
# psql -c "INSERT INTO trips(route_id,service_id,trip_id,shape_id) SELECT route_id,service_id,trip_id,shape_id FROM tmp_trips"
psql -c "INSERT INTO trips_networks(route_id,shape_id) SELECT DISTINCT route_id,shape_id FROM tmp_trips"
psql -c "DROP TABLE tmp_trips"
psql -c "UPDATE trips_networks SET customer_id='$CUSTOMER_ID' WHERE customer_id IS NULL"

COLS=$(echo "$ROUTES_COLS" | sed -e 's/,/ TEXT,/g' | sed -e 's/\r//g' | sed -e 's/\n//g')
CREATE_TABLE_TMP_ROUTES="CREATE TABLE IF NOT EXISTS tmp_routes (${COLS} TEXT);"
psql -c "$CREATE_TABLE_TMP_ROUTES"
psql -c "\copy tmp_routes($ROUTES_COLS) FROM 'tmp/routes.txt' WITH CSV HEADER NULL AS ''"
psql -c "INSERT INTO routes_networks(route_id,route_short_name,route_long_name,route_type) SELECT route_id,route_short_name,route_long_name,route_type::NUMERIC FROM tmp_routes"
psql -c "DROP TABLE tmp_routes"
psql -c "UPDATE routes_networks SET customer_id='$CUSTOMER_ID' WHERE customer_id IS NULL"

COLS=$(echo "$SHAPES_COLS" | sed -e 's/,/ TEXT,/g' | sed -e 's/\r//g' | sed -e 's/\n//g')
CREATE_TABLE_TMP_SHAPES="CREATE TABLE IF NOT EXISTS tmp_shapes (${COLS} TEXT);" 
psql -c "$CREATE_TABLE_TMP_SHAPES"
psql -c "\copy tmp_shapes($SHAPES_COLS) FROM 'tmp/shapes.txt' WITH CSV HEADER NULL AS ''"
psql -c "INSERT INTO shapes_networks(shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled) SELECT shape_id,shape_pt_lat::REAL,shape_pt_lon::REAL,shape_pt_sequence::NUMERIC,shape_dist_traveled::NUMERIC FROM tmp_shapes"
psql -c "DROP TABLE tmp_shapes"
psql -c "UPDATE shapes_networks SET customer_id='$CUSTOMER_ID' WHERE customer_id IS NULL"

# Dump routes to generate networks and waypoints
echo "SET work_mem = '2GB';
\copy (SELECT routes_networks.route_type, shapes_networks.shape_id, shapes_networks.shape_pt_lat, shapes_networks.shape_pt_lon, shapes_networks.shape_pt_sequence, shapes_networks.shape_dist_traveled FROM shapes_networks INNER JOIN trips_networks ON trips_networks.shape_id=shapes_networks.shape_id INNER JOIN routes_networks ON trips_networks.route_id=routes_networks.route_id WHERE trips_networks.customer_id='$CUSTOMER_ID' AND routes_networks.customer_id='$CUSTOMER_ID' AND shapes_networks.customer_id='$CUSTOMER_ID' ORDER BY shapes_networks.shape_id, shapes_networks.shape_pt_sequence) TO 'tmp/tmp_routes.csv' WITH CSV HEADER NULL AS '';
RESET work_mem;" > tmp/tmp_dump_routes.sql
psql -f tmp/tmp_dump_routes.sql

# Build networks for pathfinding
python3 make_gtfs_graphs.py tmp/tmp_routes.csv "$CUSTOMER_ID"
python3 check_gtfs_graphs.py tmp/tmp_routes.csv "$CUSTOMER_ID"
# Cleanup tmp files
# rm tmp/*
