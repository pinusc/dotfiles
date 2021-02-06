#!/usr/bin/env bash
env > /tmp/envuser

IFS='' read -r -d '' helpstring <<EOF
dock_handler.sh - A simple script to handle monitor/peripherals on dock

Usage: dock_handler.sh [DOCK]

Options:
    DOCK       either 'dock' or 'undock'

EOF

case "$1" in
    dock)
        DOCKED=1;
        ;;
    undock)
        DOCKED=0;
        ;;
    -h|--help|*)
        echo -n "$helpstring"
        echo "DOCK ARG"
        echo "$1"
        exit 1;
        ;;
esac

if [[ "$DOCKED" = 1 ]]; then
    echo "docky docked"
    xrandr --auto
    monitor=$(xrandr --listmonitors | awk '{ print $4; }' | grep '.' | grep -v 'LVDS1' | head -n 1)
    case "$monitor" in
        HDMI2)
            xrandr --newmode "1366x768"x0.0   69.30  1366 1404 1426 1436  768 771 777 803 -hsync -vsync
            xrandr --addmode HDMI2 "1366x768"x0.0
            xrandr --output HDMI2 --right-of LVDS1 --mode "1366x768"x0.0 --gamma 1 --output LVDS1 --primary
            ;;
        VGA1)
            echo "VGA"
            xrandr --output VGA1 --right-of LVDS1 --output LVDS1 --primary
            ;;
    esac
else
    echo "docky undocked"
    xrandr --auto
    "$XDG_CONFIG_HOME"/bspwm/bspc_monitors.sh
fi
killall panel; panel &>/dev/null &
disown
~/bin/util/wallpaper/random_wallpaper.sh
