package pathfinding

import (
	"os"
	"math"
	"encoding/json"
	"io/ioutil"
)

// type Points struct {
// 	Locs [][]float64 `json:"points"`
// }

// var points Points
var points map[string][][]float64

func init() {
	return
	file, e := ioutil.ReadFile("./networks/"+CUSTOMER+"/points.json")
    if e != nil {
        Error.Printf("File error: %v\n", e)
        os.Exit(1)
    }
    json.Unmarshal(file, &points)
}

func LoadWayPoints() {
	file, e := ioutil.ReadFile("./networks/"+CUSTOMER+"/points.json")
    if e != nil {
        Error.Printf("File error: %v\n", e)
        os.Exit(1)
    }
    json.Unmarshal(file, &points)
}

// haversin(θ) function
func hsin(theta float64) float64 {
	return math.Pow(math.Sin(theta/2), 2)
}

// Distance function returns the distance (in meters) between two points of
//     a given longitude and latitude relatively accurately (using a spherical
//     approximation of the Earth) through the Haversin Distance Formula for
//     great arc distance on a sphere with accuracy for small distances
//
// point coordinates are supplied in degrees and converted into rad. in the func
//
// distance returned is METERS!!!!!!
// http://en.wikipedia.org/wiki/Haversine_formula
func Distance(lat1, lon1, lat2, lon2 float64) float64 {
	// convert to radians
	// must cast radius as float to multiply later
	var la1, lo1, la2, lo2, r float64
	la1 = lat1 * math.Pi / 180
	lo1 = lon1 * math.Pi / 180
	la2 = lat2 * math.Pi / 180
	lo2 = lon2 * math.Pi / 180

	r = 6378100 // Earth radius in METERS

	// calculate
	h := hsin(la2-la1) + math.Cos(la1)*math.Cos(la2)*hsin(lo2-lo1)

	return 2 * r * math.Asin(math.Sqrt(h))
}


func GetWayPoint(graph_name string, x float64, y float64) ([]float64){
	shortest := 100000000000.00
	c := 0
	for i := range points[graph_name] {
		dist := Distance(y, x, points[graph_name][i][1], points[graph_name][i][0])
		if dist < shortest {
			shortest = dist
			c = i
		}
	}

	return points[graph_name][c]
}
