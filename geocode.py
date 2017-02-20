import sys
import requests

def main(address):
    uri = 'http://geocoding.geo.census.gov/geocoder/locations/onelineaddress'
    params = { 
        "address": address,
        "format": "json", 
        "benchmark": 9 
    }
    r = requests.get(uri,params)
    data = r.json()
    lon = data["result"]["addressMatches"][0]["coordinates"]["x"]
    lat = data["result"]["addressMatches"][0]["coordinates"]["y"]
    print(lon,lat)

if __name__ in "__main__":
    main(sys.argv[1])