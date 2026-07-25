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

case "$profile_name" in
    breathing )
        openrgb --mode "breathing" --client localhost
        ;;
    rainbow )
        openrgb --mode "rainbow" --client localhost
        ;;
    random )
        openrgb --color "random" --client localhost
        ;;
    pick )
        color="$(kcolorchooser --print | tr -d '#')"
        openrgb --color "$color" --client localhost
        ;;
    hwmonitor )
        openrgb --config /home/giusb/.config/OpenRGB/hwmonitor-mode --client localhost
        ;;
    "" )
        ;;
    * )
        openrgb -p "$profile_file" --client localhost
        ;;
esac
