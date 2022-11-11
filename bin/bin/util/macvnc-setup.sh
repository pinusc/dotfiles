#!/usr/bin/env bash

sh bin/util/wallpaper/random_wallpaper.sh
xrandr --output VNC-0 --primary
bspc config -m VNC-0 top_padding 55
killall panel; panel &>/dev/null & disown
