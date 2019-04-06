#!/bin/sh

source ~/.dmenurc

COMMANDS="
suspend\n
poweroff\n
reboot\n
hibernate\n
hybrid-sleep\n
halt\n
lock\n
"
# dmenu_run -h $h -w $w -l 1 -q -p "                         execute" -fn "$font" -nb "#2d2d2d" -nf "#dedede" -sb "#2d2d2d" -sf "#8b9dc3"
    # dmenu -p "Power:" -fn "$FONT" -nb $BGCOL -nf $FGCOL -sb $SELBGCOL -sf $SELFGCOL)

command=$(echo -e $COMMANDS | $dmenu_command -p "power:")
[ "$command" = "" ] && exit 1
if [[ "${command#?}" = "lock" ]]; then
    lock
else
    systemctl $command
fi
exit 0
