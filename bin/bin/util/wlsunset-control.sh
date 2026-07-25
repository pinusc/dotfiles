#!/usr/bin/bash
set -x

if [ "$1" = "disable" ]; then
    if pgrep -x wlsunset >/dev/null 2>&1; then
        pkill wlsunset >/dev/null 2>&1
    fi
elif [ "$1" = "enable" ]; then
    if ! pgrep -x wlsunset >/dev/null 2>&1; then
        location="$(geolocate)"
        lat="$(echo "$location" | cut -d, -f1)"
        lng="$(echo "$location" | cut -d, -f2)"
        nohup wlsunset -l "$lat" -L "$lng" -t 3000 -T 6500 > /tmp/wlsunset.log 2>&1 &
    fi
else
    echo 'Usage: wlsunset-control.sh [ENABLE]'
    echo 'where ENABLE is either `enable` or `disable`'
fi
