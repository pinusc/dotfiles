#!/bin/bash

IFS='' read -r -d '' helpstring <<EOF
Usage: unsplash_wallpaper.sh -i ID [OPTIONS]

Options:
    -h      Display this help
    -c      Categories
    -i ID   Unsplash ClientID
    -f      Only download featured images
    -c N    Download N images instead of querying the number of monitors
    -s DIR  Save the images in DIR instead of tmp
    -l      List collections (can be used with -f)
    -b      Set background with feh after downloading pictures
    -q      Query
EOF


while getopts ":hlfc:s:C:bi:q:" option; do
    case $option in
        h) echo "$helpstring" && exit 0;;
        f) featured="&featured";;
        c) count="&count=$OPTARG";;
        C) collections="&collections=$OPTARG";;
        i) clientid="&client_id=$OPTARG";;
        s) savedir="$OPTARG";;
        l) listcategories=1;;
        b) setbg=1;;
        q) query="&query=$OPTARG";;
        *) echo "$helptstring" && exit 1;;
    esac
done

APIURL="https://api.unsplash.com/"
json_file=$(mktemp "/tmp/unsplash_query.XXXX.json")
json_file="/tmp/unsplash_query.F5ak.json"
clientid="?client_id=7e5ee1affa3137cc974010d7ba5c07878eae3d2ac6c56d07f0a0b28c2e4ed4e7"
# sig="?sig="$(head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 4)
sig="&sig=1234"

if [[ -n "$listcategories" ]]; then
    if [[ -n "$featured" ]]; then
        featurl="featured/"
    fi
    if [[ -n "$query" ]]; then
        curl "$APIURL/search/collections/${clientid}${query}&per_page=20" > "$json_file"
        echo -e "ID\tTitle"
        < "$json_file" jq -r '.results | map(@text "\(.id)\t\(.title)") | .[]' 
    else
        curl "$APIURL/collections/${featurl}${clientid}" > "$json_file"
        echo -e "ID\tTitle"
        < "$json_file" jq -r 'map(@text "\(.id)\t\(.title)") | .[]' 
    fi
    exit 0
fi

if [[ -z "$count" ]]; then
   count=1
   # if xrandr is installed:
   # downloads as many images as there are monitors connected
   command -v xrandr >/dev/null 2>&1 && count=$(xrandr --query | grep -c " connected")
   echo "COUNT=$count"
fi

curl "$APIURL/photos/random/${clientid}${collections}${query}${featured}&count=30&orientation=landscape" > "$json_file"
if [[ -z "$savedir" ]]; then
    savedir=$(mktemp -d "/tmp/unsplash.XXXX")
fi
urls=$(< "$json_file" jq -r 'map(@text "\(.id) \(.urls.full)")[]' )
urls=$(echo "$urls" | shuf | head -n "$count")
files=""
while read -r id url; do
    fname="$savedir/unsplash_$id.jpg"
    wget "$url" -O "$fname"
    files="$files $fname"
done <<< "$urls"

# Set backround here
if [[ -n "$setbg" ]]; then
    echo feh --bg-fill $files
    feh --bg-fill $files
fi
