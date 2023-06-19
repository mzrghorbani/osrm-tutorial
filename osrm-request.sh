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

# Check if route.geojson file exists
if [ -f route.geojson ]; then
    rm route.geojson  # Delete the file if it exists
fi

# Save response as GeoJSON
echo "$response" > route.geojson

echo "Route from $name1 to $name2 is saved as route.geojson"
