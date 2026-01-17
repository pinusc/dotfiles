#!/usr/bin/bash
set -x

readarray -t wallpapers < <(find ~/.wallpaper -type f | shuf)

n=0
hyprctl monitors -j | jq -r '.[] | .name' | while IFS= read -r monitor; do
    (( n += 1 ))
    # hyprctl hyprpaper preload "${wallpapers[n]}"
    hyprctl hyprpaper wallpaper "$monitor,${wallpapers[n]}"
done
