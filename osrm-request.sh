#!/bin/bash

# Location details
name1='London'
lat1=51.50837083467904
lon1=-0.13187578769508834
name2='Birmingham'
lat2=52.498968318134516
lon2=-1.8030022360693643

# Prepare API request URL
api_url="http://localhost:5000/route/v1/driving/${lon1},${lat1};${lon2},${lat2}?alternatives=true&steps=true&geometries=polyline&overview=full"

# Send request and save response
response=$(curl -s "$api_url")

# Save response as GeoJSON only if the file is empty
if [ ! -s route.geojson ]; then
    echo "$response" > route.geojson
fi

echo "Route from $name1 to $name2 is saved as route.geojson"
