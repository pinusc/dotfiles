#!/usr/bin/env bash

if [[ "$1" = "-h" || "$1" = "--help" ]]; then
    cat<<EOF
    Usage: apdf [search-term]
    Find and open a pdf file from ~/docs, ~/books, ~/downloads, ~/tmp, with rofi
EOF
fi

set -Eeuo pipefail

FOLDERS=(books docs downloads tmp)
FORMATS=(-e pdf -e epub -e djvu)

cd "$HOME"
fname="$(cd "$HOME"; fd --base-directory "$HOME" -I . -e "${FORMATS[@]}" "${FOLDERS[@]}" | rofi -dmenu -i)"

if [[ -f "$fname" ]]; then
    "$PDF_VIEWER" "$fname" &
    disown
else
    exit 1
fi
