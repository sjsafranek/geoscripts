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
    for row in reader:

        try:

            graph = "graph_" + leftPad(int(row['route_type']))
            if graph not in networks:
                networks[graph] = {}

            point = [
                float(row['shape_pt_lon']), 
                float(row['shape_pt_lat'])]
            
            v1 = str(point[0]) +","+ str(point[1])
            if v1 not in networks[graph]:
                networks[graph][v1] = {}
            
            if int(row['shape_pt_sequence']) != 1:
                v0 = str(previous[0]) +','+ str(previous[1])
                # Skip of already in network
                if v1 not in networks[graph][v0] and v1 != v0:
                    dist = great_circle(
                        (previous[0], previous[1]),
                        (point[0],    point[1])
                    )
                    networks[graph][v0][v1] = dist.meters

            previous = [
                float(row['shape_pt_lon']), 
                float(row['shape_pt_lat'])]

        except Exception as e:
            # print(e)
            # print(row)
            pass

# save graphs
for i in networks:
    d = os.path.join("pathfinding","networks",name)
    if not os.path.exists(d):
        os.makedirs(d)
    fname = os.path.join(d,i+".json")
    with open(fname, 'w') as f:
        network = {i: networks[i]}
        json.dump(network, f, ensure_ascii=False)

# save points
fname = os.path.join("pathfinding","networks",name,"points.json")
with open(fname, 'w') as f:
    waypoints = {}
    for network in networks:
        waypoints[network] = []
        for point in networks[network].keys():
            point = point.split(",")
            waypoints[network].append([
                float(point[0]),
                float(point[1])])
    json.dump(waypoints, f, ensure_ascii=False)





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
