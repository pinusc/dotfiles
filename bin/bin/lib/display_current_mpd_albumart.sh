#!/bin/bash
CURRENT_DIR="$HOME/.cache/covers/current"
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
        echo "Album path: $album_path"
        images_in_albumdir="$(find "$album_path" -name '*.jp*g' -o -name '*.png')"
        cover_in_albumdir="$(find "$album_path" -name 'cover.jp*g' -o -name 'cover.png')"
        if [[ -n "$cover_in_albumdir" ]]; then
            cp "$(echo "$cover_in_albumdir" | head -n 1)" "$fname"
        elif [[ -n "$images_in_albumdir" ]]; then
            # hope for the best, the image is not named "cover" but hopefully the first
            # image in the directory is an album cover
            cp "$(echo "$images_in_albumdir" | head -n 1)" "$fname"
        else
            echo "$artist" 
            echo "$album"
            echo "$stub"
            echo "############################################"
            echo "############################################"
            ~/bin/panel/dzen2/scripts/cover_fetcher "$artist" "$album" "$stub" # &> /dev/null
        fi

        # if [[ ! -e "$fname" ]]; then
        #     curl -L "https://source.unsplash.com/random/500x500/" >"$fname" 2>/dev/null
        # fi
    fi

    echo "$fname"

    [[ -f "$fname" ]] && cp "$fname" "$CURRENT_DIR"
}
do_display 

if [[ "$1" = "-c" ]]; then
    while true; do
        sleep 1
        clear
        do_display &>/dev/null
    done
fi
