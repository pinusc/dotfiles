#! /usr/bin/bash

redshift -t 6500:2000 -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq -r '"\(.location.lat):\(.location.lng)"') &>~/tmp/redshift.log & disown
