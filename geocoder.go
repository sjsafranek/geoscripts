package main

import (
	"fmt"
	"net/http"
	"os"
	"io/ioutil"
	"encoding/json"
	"flag"
)



type GeocodeApiAddress struct {
	Address 	string 		`json:"address"`
}
type GeocodeApiBenchmark struct {
	Id						string 		`json:"id"`
	BenchmarkName 			string 		`json:"benchmarkName"`
	BenchmarkDescription 	string 		`json:"benchmarkDescription"`
	isDefault 				string 		`json:"isDefault"`
}
type GeocodeApiInput struct {
	Address 	GeocodeApiAddress	`json:"address"`
	Benchmark 	GeocodeApiBenchmark	`json:"benchmark"`
}



type GeocodeApiCoordinates struct {
	X	float64 	`json:"x"`
	Y 	float64 	`json:"y"`
}
type GeocodeApiTigerLine struct {
	TigerLineId		string		`json:"tigerLineId"`
	Side			string		`json:"side"`
}
type GeocodeApiAddressComponents struct {
	FromAddress		string	`json:"fromAddress"`
	ToAddress		string	`json:"toAddress"`
	PreQualifier	string	`json:"preQualifier"`
	PreDirection	string	`json:"preDirection"`
	PreType			string	`json:"preType"`
	StreetName		string	`json:"streetName"`
	SuffixType		string	`json:"suffixType"`
	SuffixDirection	string	`json:"suffixDirection"`
	SuffixQualifier	string	`json:"suffixQualifier"`
	City			string	`json:"city"`
	State			string	`json:"state"`
	Zip				string	`json:"zip"`
}

type GecodeApiAddressMatches struct {
	MatchedAddress 		string 							`json:"matchedAddress"`
	Coordinates 		GeocodeApiCoordinates 			`json:"coordinates"`
	TigerLine 			GeocodeApiTigerLine 			`json:"tigerLine"`
	AddressComponents 	GeocodeApiAddressComponents 	`json:"addressComponents"`
}

type GeocodeApiResult struct {
	Input			GeocodeApiInput				`json:"input"`
	AddressMatches	[]GecodeApiAddressMatches	`json:"addressMatches"`
}

type GeocodeApiResponse struct {
	Result  GeocodeApiResult  `json:"result"`
}


func geocode(address string) GeocodeApiResponse {
	var location GeocodeApiResponse
	resp, err := http.Get("http://geocoding.geo.census.gov/geocoder/locations/onelineaddress?address=" + address + "&format=json&benchmark=9")
	if err != nil {
		fmt.Printf("%s", err)
		os.Exit(1)
	} else {
		body, _ := ioutil.ReadAll(resp.Body)
		err := json.Unmarshal(body,&location)
		if err != nil {
			fmt.Printf("%s", err)
			fmt.Println(string(body))
			os.Exit(1)
		}
	}
	return location
}



func main() {
	// Command line args
	address := flag.String("address", "NONE", "address to geocode")
	flag.Parse() 
	if *address != "NONE" {
		location := geocode(*address)
		lon := location.Result.AddressMatches[0].Coordinates.X
		lat := location.Result.AddressMatches[0].Coordinates.Y
		fmt.Println(lon,lat)
	} else {
		fmt.Println("Incorrect usage!!")
	}
}