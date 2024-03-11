#!/usr/bin/bash
set -x

if [ "$1" = "disable" ]; then
    if pgrep -x wlsunset >/dev/null 2>&1; then
        pkill wlsunset >/dev/null 2>&1
    fi
elif [ "$1" = "enable" ]; then
    if ! pgrep -x wlsunset >/dev/null 2>&1; then
        geolocate="$(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue")" 
        lat="$(echo "$geolocate" | jq -r '"\(.location.lat)"')"
        lng="$(echo "$geolocate" | jq -r '"\(.location.lng)"')"
        nohup wlsunset -l "$lat" -L "$lng" -t 3000 -T 6500 > /tmp/wlsunset.log 2>&1 &
    fi
else
    echo 'Usage: wlsunset-control.sh [ENABLE]'
    echo 'where ENABLE is either `enable` or `disable`'
fi
