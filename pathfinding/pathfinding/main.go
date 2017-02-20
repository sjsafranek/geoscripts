/*=======================================*/
//	project: british rails
//	author: stefan safranek
//	email: sjsafranek@gmail.com
/*=======================================*/

package pathfinding

import (
	// "flag"
	// "fmt"
	// "strings"
)

var (
	CUSTOMER string
)

// func init() {
// 	flag.StringVar(&CUSTOMER, "c", "", "customer [*required]")
// 	flag.Parse()
// 	return
// 	if "" == CUSTOMER {
// 		Error.Fatal("Please provide customer_name")
// 	}
// }

// func main() {
	// return
	// waypoint1 := GetWayPoint("graph_03",-122.6693, 45.4377)
	// waypoint2 := GetWayPoint("graph_03",-122.7644, 45.4293)
	// Info.Println("waypoints:",waypoint1, waypoint2)
	// pt1 := fmt.Sprintf("%v,%v",waypoint1[0], waypoint1[1])
	// pt2 := fmt.Sprintf("%v,%v",waypoint2[0], waypoint2[1])
	// path, err := ShortestPathPoints("graph_03",pt1, pt2)
	// if err != nil {
	// 	Error.Println(err)
	// 	Error.Fatal("Unable to generate path")
	// }

	// // Info.Println(path)

	// locations := ""
	// for i := range path {
	// 	p0 := strings.Split(path[i].String(), ",")
	// 	if len(p0) == 2 {
	// 		locations += "["+p0[0]+","+p0[1]+"],"
	// 	}
	// }

	// l := len(locations)
	// locations = locations[0:l-1]

	// geojson := `{ "type": "FeatureCollection",
	// 	"features": [
	// 		{
	// 			"type": "Feature",
	// 			"geometry": {"type": "Point", "coordinates": [-122.677396, 45.522913]},
	// 			"properties": {
	// 				"name": "start"
	// 			}
	// 		},
	// 		{
	// 			"type": "Feature",
	// 			"geometry": {"type": "Point", "coordinates": [-122.775017, 45.344898]},
	// 			"properties": {
	// 				"name": "end"
	// 			}
	// 		},
	// 		{
	// 			"type": "Feature",
	// 			"geometry": {
	// 			"type": "LineString",
	// 			"coordinates": [`+locations+`]
	// 			},
	// 		"properties": {
	// 			"name": "path",
	// 			"start": "`+pt1+`",
	// 			"end": "`+pt2+`"
	// 			}
	// 		}
	// 	]
	// }`

	// Info.Println(geojson)

// }

