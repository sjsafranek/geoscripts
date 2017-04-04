from osgeo import ogr
from osgeo import osr

source = osr.SpatialReference()
source.ImportFromEPSG(4326)

target = osr.SpatialReference()
target.ImportFromEPSG(3857)

transform = osr.CoordinateTransformation(source, target)

point_1 = ogr.CreateGeometryFromWkt("POINT (-124.0010000 42.9994000)")
point_1.Transform(transform)
print point_1.ExportToWkt()

point_2 = ogr.CreateGeometryFromWkt("POINT (-122.0000000 42.9994000)")
point_2.Transform(transform)
print point_2.ExportToWkt()

print point_1.Distance(point_2)
print point_1.Distance(point_2) / 10