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
    try:
        lon = data["result"]["addressMatches"][0]["coordinates"]["x"]
        lat = data["result"]["addressMatches"][0]["coordinates"]["y"]
        print("POINT("+str(lon)+" "+str(lat)+")")
    except Exception as e:
        print(e)

if __name__ in "__main__":
    address = ' '.join( sys.argv[1:] )
    print(address)
    #main(sys.argv[1])
    main(address)
