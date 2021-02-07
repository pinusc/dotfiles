#!/bin/bash

if [[ -n "$1" ]]; then
    cat <<EOF
Usage: wallpaper_menu

A rofi/dmenu script to randomize the wallpaper.
It allows for various methods of setting the wallpaper, which you can select in the first screen.
    - "Unsplash" asks you for a query (can be blank), and then downloads pertinent images from unsplash
    - "Directory" sets the wallpaper from random pictures in $HOME/.wallpaper
    - "Fortune" uses fortune and imagemagick to generate quotation wallpapers
EOF
fi

method=$(echo "Unsplash|Directory|Fortune" | rofi -i -sep '|' -dmenu -p "Which method to set wallpaper? " -a)

case "$method" in
    Unsplash)
        query=$(rofi -dmenu -p "Wallpaper query" -a -5)
        ~/bin/util/wallpaper/unsplash_wallpaper.sh -bfq "$query"
        ;;
    Directory)
        ~/bin/util/wallpaper/random_wallpaper.sh
        ;;
    Fortune)
        ~/bin/util/wallpaper/fortune_wallpaper.sh
        ;;
    *)
        exit 1
        ;;
esac
exit 0




