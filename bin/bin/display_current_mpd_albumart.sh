#!/bin/bash
clear
sleep 1
do_display() {
    artist="$(mpc -f '%artist%' | head -n 1)"
    album="$(mpc -f '%album%' | head -n 1)"

    fname="$HOME/.cache/covers/$artist/${album}-large.png"

    if [[ ! -e "$fname" ]]; then
        ~/bin/panel/dzen2/scripts/cover_fetcher "$artist" "$album" ~/.cache/covers &> /dev/null
        if [[ ! -e "$fname" ]]; then
            curl -L "https://source.unsplash.com/random/500x500/" > "$fname"
        fi
    fi

    img-display.sh "$fname"
}
do_display

if [[ "$1" = "-c" ]]; then
    while true; do
        sleep 1
        clear
        do_display
    done
fi
