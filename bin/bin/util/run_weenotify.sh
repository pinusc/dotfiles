#!/usr/bin/env bash

WEENOTIFY_DIR="$HOME/builds/weenotify"
LOOKUP_FILE="$WEENOTIFY_DIR/phonelookup.txt"

khard phone --parsable | 
    sort -k1 -u | 
    sed 's/[()]//g; s/\([0-9]\)[ -]\([0-9]\)/\1\2/g; s/^+\?/\&w-/' | 
    cut -f1,2 -d $'\t' --output-delimiter ',' | grep ',' > "$LOOKUP_FILE"
python "${WEENOTIFY_DIR}/weenotify.py" -s -c "$LOOKUP_FILE"

trap 'kill $(jobs -p)' EXIT
