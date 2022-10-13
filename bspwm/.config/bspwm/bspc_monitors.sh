#!/bin/bash

NMON=$(xrandr --query | grep " connected" | wc -l)
old_bspc_nmon="$(bspc query -M | wc -l)"

bspc monitor "^1" -d \
    $(echo -e '\uf0c3')   `# flask` \
    $(echo -e '\uf109')   `# desktop` \
    $(echo -e '\uf025')   `# music` \
    $(echo -e '\uf0e0')   `# mail` \
    $(echo -e '\uf15c')   `# document` \
    $(echo -e '\uf0ac')   `# internet` \
    $(echo -e '\uf121')   `# editor` \
    $(echo -e '\uf120')   `# terminal ` \
    $(echo -e '\uf135')   `# rocket` \
    $(echo -e '\uf2db')   `# microchip` \
    $(echo -e '\uf21e')   `# hearthbeat`
if [[ NMON -gt 1 ]]; then
    bspc monitor "^2" -d \
        $(echo -e '\uf121')  `# editor` \
        $(echo -e '\uf120')  `# terminal` \
        $(echo -e '\uf02d')  `# man` \
        $(echo -e '\uf025')  `# music` \
        $(echo -e '\uf15c')  `# document` \
        $(echo -e '\uf0ac')  `#internet` \
        $(echo -e '\uf21e')  `# heartbeat` \
        $(echo -e '\uf094')  `# lemon` \
        $(echo -e '\uf130')  `# phone` \
        $(echo -e '\uf2db')  `# microchip` \
        $(echo -e '\uf21e')  `# hearthbeat`
fi
if [[ NMON -gt 2 ]]; then
    bspc monitor "^3" -d \
        $(echo -e '\uf121')  `# editor` \
        $(echo -e '\uf120')  `# terminal` \
        $(echo -e '\uf02d')  `# man` \
        $(echo -e '\uf025')  `# music` \
        $(echo -e '\uf15c')  `# document` \
        $(echo -e '\uf0ac')  `#internet` \
        $(echo -e '\uf21e')  `# heartbeat` \
        $(echo -e '\uf094')  `# lemon` \
        $(echo -e '\uf130')  `# phone` \
        $(echo -e '\uf2db')  `# microchip` \
        $(echo -e '\uf21e')  `# hearthbeat`
fi

# if number of monitor changed from or to two monitors
# if [ \( "$old_bspc_nmon" -ne "$NMON" \) -a \
#     \( \( "$old_bspc_nmon" -eq 2 \) -o \( "$NMON" -eq 2 \) \) ]; then
#     # swap necessary because primary display changes
#     # if only LVDS1 is connected now, it should be primary (but wasn't, so swap)
#     # if two are connected now, external should be primary (but wasn't, so swap)
#     bspc monitor --swap "^1" "^2"
# fi

primary=$(bspc query -M -m 'primary')

# delete old monitor, adopt orphaned nodes in a new desktop of the current monitor
if [[ "$old_bspc_nmon" -gt "$NMON" ]]; then
    old_mons="$(bspc query -M | grep -v "$primary")"
    for old_mon in $old_mons; do
        bspc monitor "$old_mon" -r
    done
    bspc monitor "^1" -a 'O'
    bspc desktop 'O' -f
    bspc wm --adopt-orphans
fi
