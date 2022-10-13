#!/bin/bash

IFS='' read -r -d '' helpstring <<EOF
Usage: nasa_wallpaper.sh
Downloads the NASA image of the day from https://apod.nasa.gov/apod/astropix.html and sets it as the wallpaper. 
EOF

BASEURL=https://apod.nasa.gov/apod
htmlfile="$(mktemp --tmpdir nasa-XXXX.html)"
curl -s "$BASEURL/astropix.html" -o "$htmlfile"
imgname=$(cat "$htmlfile" | tr -d '\n' \
    | sed 's/.*\(img\|IMG\) \(src\|SRC\)="\([^\"]*\).*/\3/')

imgfile="$(mktemp)"
curl -s "$BASEURL/$imgname" -o "$imgfile"

if which w3m &>/dev/null; then
    urxvt -e w3m "$htmlfile" &>/dev/null &
fi

# Set backround here
echo feh --bg-fill "$imgfile"
feh --bg-fill "$imgfile"
