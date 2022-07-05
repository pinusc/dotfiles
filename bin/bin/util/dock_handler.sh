#!/usr/bin/env bash
env > /tmp/envuser

IFS='' read -r -d '' helpstring <<EOF
dock_handler.sh - A simple script to handle monitor/peripherals on dock

Usage: dock_handler.sh [DOCK]

Options:
    DOCK       either 'dock' or 'undock'

EOF

if [[ -z "$1" ]]; then
    if grep -q 1 /sys/devices/platform/dock.1/docked; then
        DOCKED=1
    else
        DOCKED=0
    fi
fi


case "$1" in
    dock)
        DOCKED=1;
        ;;
    undock)
        DOCKED=0;
        ;;
    -h|--help)
        echo -n "$helpstring"
        echo "DOCK ARG"
        echo "$1"
        exit 1;
        ;;
esac

if [[ "$DOCKED" = 1 ]]; then
    echo "docky docked"
    xrandr --auto
    # Here nmonitors is the number of _external_ displays
    nmonitors=$(xrandr --listmonitors | awk '{ print $4; }' | grep '.' | grep -c -v 'LVDS')
    # monitor is (hopefully) the primary external display
    monitor=$(xrandr --listmonitors | awk '{ print $4; }' | grep '.' | grep -v 'LVDS' | head -n 1)
    echo "$nmonitors"
    if [ "$nmonitors" -eq 2 ]; then
        # special config for three monitors
        xrandr --output VGA1 --auto
        xrandr --output HDMI2 --auto
        xrandr --output HDMI2 --right-of LVDS1 --output VGA1 --right-of HDMI2
    else
        case "$monitor" in
            DP2)
                # remember to set primary correctly for bar reasons
                xrandr --output DP2 --primary --mode 2560x1080
                xrandr --output LVDS1 --left-of DP2
                ;;
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
    fi
else
    echo "docky undocked"
    xrandr --auto
    # remember to set primary correctly for bar reasons
    xrandr --output LVDS1 --primary
fi
"$XDG_CONFIG_HOME"/bspwm/bspc_monitors.sh
killall panel; panel &>/dev/null &
disown
~/bin/util/wallpaper/random_wallpaper.sh
