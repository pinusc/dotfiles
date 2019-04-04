#!/bin/bash
clear
sleep 1
do_display() {
    if [ -z "$(mpc current)" ]; then
        # playlist is empty
        clear
        return 1
    fi
    artist="$(mpc -f '[%albumartist%|%artist%]' | head -n 1)"
    album="$(mpc -f '%album%' | head -n 1)"

    # so as not to incur in problems with e.g. AC/DC
    artist_dir=$(echo "$artist" | tr -cd '[:alnum:]')
    album_dir=$(echo "$album" | tr -cd '[:alnum:]')
    stub="$HOME/.cache/covers/$artist_dir/${album_dir}"
    fname="$stub-large.png"
    [[ ! -d "${stub%/*}" ]] && mkdir -p "${stub%/*}" 

    if [[ ! -e "$fname" ]]; then
        # check if we already have the cover
        MUSIC_ROOT="$HOME/music"
        song_path="$MUSIC_ROOT/$(mpc -f '%file%' | head -n 1)"
        album_path="${song_path%/*}"
        echo "$album_path"
        if [[ -e "${album_path}/cover.jpg" ]]; then
            cp "$album_path/cover.jpg" "$fname"
        else
            ~/bin/panel/dzen2/scripts/cover_fetcher "$artist" "$album" "$stub" &> /dev/null
        fi

        if [[ ! -e "$fname" ]]; then
            curl -L "https://source.unsplash.com/random/500x500/" >"$fname" 2>/dev/null
        fi
    fi

    img-display.sh "$fname"
}
do_display &>/dev/null

if [[ "$1" = "-c" ]]; then
    while true; do
        sleep 1
        clear
        do_display &>/dev/null
    done
fi
