import os
import csv
import sys
import json
import geopy
import logging
from geopy.distance import great_circle

# https://github.com/gyuho/learn/blob/master/doc/go_graph_shortest_path/code/graph.json

# command line args
file = sys.argv[1]
name = sys.argv[2]

# check file
if not os.path.exists(file):
    print("File not found")
    exit()

# result
networks = {
    "graph_00": {},
    "graph_01": {},
    "graph_02": {},
    "graph_03": {},
    "graph_04": {},
    "graph_05": {},
    "graph_06": {},
    "graph_07": {}
}

def leftPad(value):
    string = str(value)
    if 1 == len(string):
        string = '0'+string
    return string


# read file
with open(file) as csvfile:
    
    previous = []

    reader = csv.DictReader(csvfile)
    shape_id = None
    for row in reader:
        try:

            graph = "graph_" + leftPad(int(row['route_type']))
            if graph not in networks:
                networks[graph] = {}

            shape_id = row["shape_id"]
            if shape_id not in networks[graph]:
                networks[graph][shape_id] = []

            point = [float(row['shape_pt_lon']), float(row['shape_pt_lat'])]
            if point not in networks[graph][shape_id]:
                networks[graph][shape_id].append(point)

        except Exception as e:
            # print(e)
            # print(row)
            pass

# # save graphs
for graph in networks:
    d = os.path.join("pathfinding","networks",name)
    if not os.path.exists(d):
        os.makedirs(d)
    fname = os.path.join(d,graph+".geojson")
    with open(fname, 'w') as f:
        
        network = {
            "type": "FeatureCollection",
            "features": []
        }
        for shape_id in networks[graph]:
            feature = { "type": "Feature",
                "geometry": {
                    "type": "LineString",
                    "coordinates": networks[graph][shape_id]
                },
                "properties": {
                    "shape_id": shape_id,
                }
            }
            network["features"].append(feature)

        json.dump(network, f, ensure_ascii=False)




'''

https://github.com/gyuho/learn/tree/master/doc/go_graph_shortest_path
https://github.com/gyuho/learn/blob/master/doc/go_graph_shortest_path/code/graph.json


https://github.com/soniakeys/graph
https://github.com/soniakeys/graph/blob/master/tutorials/dijkstra.md
https://play.golang.org/p/lH2f_jcvzm


'''



# for feature in data['features']:
#     previous = None
#     for point in feature['geometry']['coordinates']:
#         v1 = str(round(point[0],5)) + ',' + str(round(point[1],5))
#         if v1 not in networks['graph_00']:
#             networks['graph_00'][v1] = {}
#         if previous:
#             v0 = str(round(previous[0],5)) + ',' + str(round(previous[1],5))
#             dist = great_circle(
#                 (round(previous[0],5),round(previous[1],5)),
#                 (round(point[0],5), round(point[1],5))
#             )
#             networks['graph_00'][v0][v1] = dist.meters
#         previous = point
#     # bi directional
#     previous = None
#     for point in reversed(feature['geometry']['coordinates']):
#         v1 = str(round(point[0],5)) + ',' + str(round(point[1],5))
#         if v1 not in networks['graph_00']:
#             networks['graph_00'][v1] = {}
#         if previous:
#             v0 = str(round(previous[0],5)) + ',' + str(round(previous[1],5))
#             dist = great_circle(
#                 (round(previous[0],5),round(previous[1],5)),
#                 (round(point[0],5), round(point[1],5))
#             )
#             networks['graph_00'][v0][v1] = dist.meters
#         previous = point
