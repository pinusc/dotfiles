#!/bin/bash

source ~/.dmenurc

COMMANDS="suspend
poweroff
reboot
hibernate
hybrid-sleep
halt
lock
screen-off"
# dmenu_run -h $h -w $w -l 1 -q -p "                         execute" -fn "$font" -nb "#2d2d2d" -nf "#dedede" -sb "#2d2d2d" -sf "#8b9dc3"
    # dmenu -p "Power:" -fn "$FONT" -nb $BGCOL -nf $FGCOL -sb $SELBGCOL -sf $SELFGCOL)

echo -e "$COMMANDS"

command="$(echo -e "$COMMANDS" | $dmenu_command -p "power:")"
[ "$command" = "" ] && exit 1
echo $command
if [[ "${command}" = "lock" ]]; then
    lock
elif [[ "${command}" = "screen-off" ]]; then
    sleep 1
    if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
        hyprctl dispatch dpms off
    else
        xset dpms force off
    fi
else
    systemctl $command
fi
exit 0
