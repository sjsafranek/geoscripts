#!/bin/bash

ogr2ogr -f CSV output.csv example.shp -lco GEOMETRY=AS_WKT