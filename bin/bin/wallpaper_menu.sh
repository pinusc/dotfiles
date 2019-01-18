#!/bin/bash

if [[ -n "$1" ]]; then
    echo <<EOF
Usage: wallpaper_menu

A rofi/dmenu script to randomize the wallpaper.
It allows for various methods of setting the wallpaper, which you can select in the first screen.
    - "Unsplash" asks you for a query (can be blank), and then downloads pertinent images from unsplash
    - "Directory" sets the wallpaper from random pictures in $HOME/.wallpaper
    - "Fortune" uses fortune and imagemagick to generate quotation wallpapers
EOF
fi

method=$(echo "Unsplash|Directory|Fortune" | rofi -sep '|' -dmenu -p "Which method to set wallpaper? " -a)

case "$method" in
    Unsplash)
        query=$(rofi -dmenu -p "Wallpaper query" -a -5)
        unsplash_wallpaper.sh -bfq "$query"
        ;;
    Directory)
        randomwallpaper.sh
        ;;
    Fortune)
        fortunewallpaper.sh
        ;;
    *)
        exit 1
        ;;
esac
exit 0




