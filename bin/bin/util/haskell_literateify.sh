#!/bin/bash

if [[ "$#" -lt 1 ]]; then
    echo "Usage: haskell_literateify.sh FILE"
fi

f="$1"

< "$f" sed 's/^\([^-]\)/    \1/;/^--/s/$/  /; s/^-- *//;' | pandoc -o "${f%%.hs}.html"
