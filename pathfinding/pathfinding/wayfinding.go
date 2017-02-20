package pathfinding

import (
	"fmt"
	"os"
	// "time"
	"errors"
	// "math"
)

var graph_networks map[string]Graph

func init() {
	return
	graph_networks = make(map[string]Graph)
	// 0: Tram, Streetcar, Light rail. Any light rail or street level system within a metropolitan area.
	// 1: Subway, Metro. Any underground rail system within a metropolitan area.
	// 2: Rail. Used for intercity or long-distance travel.
	// 3: Bus. Used for short- and long-distance bus routes.
	// 4: Ferry. Used for short- and long-distance boat service.
	// 5: Cable car. Used for street-level cable cars where the cable runs beneath the car.
	// 6: Gondola, Suspended cable car. Typically used for aerial cable cars where the car is suspended from the cable.
	// 7: Funicular. Any rail system designed for steep inclines.
	for i:=0; i<8; i++ {
		graph_name := fmt.Sprintf("graph_0%v",i)

		f, err := os.Open("./networks/"+CUSTOMER+"/"+graph_name+".json")
		if err != nil {
			Error.Fatal(err)
		}
		defer f.Close()

		graph, err := NewGraphFromJSON(f, graph_name)
		if err != nil {
			Error.Println(err)
		}
		graph_networks[graph_name] = graph
	}

}

func LoadNetworks() {
	graph_networks = make(map[string]Graph)
	// 0: Tram, Streetcar, Light rail. Any light rail or street level system within a metropolitan area.
	// 1: Subway, Metro. Any underground rail system within a metropolitan area.
	// 2: Rail. Used for intercity or long-distance travel.
	// 3: Bus. Used for short- and long-distance bus routes.
	// 4: Ferry. Used for short- and long-distance boat service.
	// 5: Cable car. Used for street-level cable cars where the cable runs beneath the car.
	// 6: Gondola, Suspended cable car. Typically used for aerial cable cars where the car is suspended from the cable.
	// 7: Funicular. Any rail system designed for steep inclines.
	for i:=0; i<8; i++ {
		graph_name := fmt.Sprintf("graph_0%v",i)

		f, err := os.Open("./networks/"+CUSTOMER+"/"+graph_name+".json")
		if err != nil {
			Error.Fatal(err)
		}
		defer f.Close()

		graph, err := NewGraphFromJSON(f, graph_name)
		if err != nil {
			Error.Println(err)
		}
		graph_networks[graph_name] = graph
	}
}

func ShortestPathPoints(graph_name, source string, target string) ([]ID, error) {
	if graph, ok := graph_networks[graph_name]; ok {
		// t1 := time.Now()
		path, _, err := Dijkstra(graph, StringID(source), StringID(target))
		if err != nil {
			Error.Fatal(err)
		}

		// s := fmt.Sprintf("%0.4f", time.Since(t1).Seconds())
		// l := fmt.Sprintf("%v", len(path))
		// msg := `{"time":` + s + `,"points":` + l + `,"start":"` + source + `","end":"` + target + `"}`

		// Info.Println(msg)
		return path, nil
	} else {
		result := []ID{}
		return result, errors.New("Graph does not exist")
	}
}

func ShortestPathDistances(graph_name, source string, target string) (map[ID]float64, error) {
	if graph, ok := graph_networks[graph_name]; ok {
		_, distance, err := Dijkstra(graph, StringID(source), StringID(target))
		if err != nil {
			Error.Fatal(err)
		}
		return distance, nil
	} else {
		result := make(map[ID]float64)
		return result, errors.New("Graph does not exist")
	}
}
