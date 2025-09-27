#!/usr/bin/env bash

set -x

profile_dir=~/.config/OpenRGB 

profiles="$(find "$profile_dir" -name '*.orp' -exec basename {} .orp \;)"
profiles="$profiles
random
rainbow
breathing
pick"
if [ -n "$1" ]; then
    profile_name="$1"
else
    profile_name="$(echo "$profiles" | rofi -dmenu)"
fi

profile_file="${profile_dir}/${profile_name}.orp"

killall openrgb
case "$profile_name" in
    breathing )
        openrgb --mode "breathing" --startminimized
        ;;
    rainbow )
        openrgb --mode "rainbow" --startminimized
        ;;
    random )
        openrgb --color "random" --startminimized
        ;;
    pick )
        color="$(kcolorchooser --print | tr -d '#')"
        openrgb --color "$color" --startminimized
        ;;
    hwmonitor )
        openrgb --config /home/giusb/.config/OpenRGB/hwmonitor-mode --startminimized
        ;;
    "" )
        ;;
    * )
        openrgb -p "$profile_file" --startminimized
        ;;
esac
