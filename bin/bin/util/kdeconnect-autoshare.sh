#!/usr/bin/env sh

if [ "$1" = "--help " ] || [ "$1" = "-h" ] || [ "$1" = "" ]; then
    echo "Usage:"
    echo "  kdeconnect-autoshare.sh FILE"
    echo "  kdeconnect-autoshare.sh --help"
    exit 1
fi


to_share="$1"
device_line="$(kdeconnect-cli --list-available --id-name-only | rofi -dmenu -auto-select -e "Device to send to?")"
device_id="$(echo "$device_line" |  cut -d' ' -f1)"
device_name="$(echo "$device_line" |  cut -d' ' -f2-)"

kdeconnect-cli --share="$to_share" --device="$device_id"

echo "to $device_name"
