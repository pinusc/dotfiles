#!/usr/bin/env bash

INFILE="$XDG_CONFIG_HOME/waybar/style.css.def"
OUTFILE="$XDG_CONFIG_HOME/waybar/style.css"

source "$HOME/bin/lib/colors.sh"

text="$(< "$INFILE")"

for i in $( seq 0 15 );
do
    hex="$( printf "0%X" "$i" )"
    bhex=""
    eval "bhex=\${base$hex}"
    bname=base$hex
    tmptext=$(echo "$text" | sed "s/{{$bname}}/$bhex/g")
    text="$tmptext"
done

echo "$text" > "$OUTFILE"


# echo -e $text | cat - "$INFILE" | cpp -P - -o "$OUTFILE"
