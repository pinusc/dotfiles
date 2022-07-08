#!/usr/bin/env bash

if [ ! -e "$1" ]; then
    cat <<EOF 
First and second argument should be a filename (diceware word list and output
file). You should probably inspect and edit this script, it's not very
generalized.

This script generates a one-page PDF with a list of 3-word Diceware passwords.
I wrote this to generate a list of passwords my mom can use when signing on to
websites... the only "password manager" she can handle is a notebook, which is
"good enough" for her. Using passwords from this file will solve the password
reuse / trivial password problem, while still giving her passwords that are
simple to type, remember, and read.
EOF
    exit 1
fi
FILE="$1"
OUTFILE="$2"

PATTERN=_word_list_diceware_it-IT

generate_list () {
    < "$FILE"  perl -ne "print if /BEGIN${PATTERN}/../END${PATTERN}/" | tail -n +2 | head -n -1 | shuf | cut -d' ' -f2 | sed 'N;N;s/\(.*\)\n\(.*\)\n\(.*\)/\u\1\u\2\u\3/;'
}

texify () {
    # and adds instructions to use 3 columns
    echo "\begin{multicols}{4}"
    sed 's/.*/\\verb|&|\\\\/g'
    echo ""
    echo "\end{multicols}"
}

generate_list | head -n 243 | texify | pandoc - --from markdown --to pdf -o "$OUTFILE" -V geometry="margin=1cm" -V header-includes="\usepackage{multicol}" -V mainfont="IBM Plex Mono" -V pagestyle=empty --pdf-engine=xelatex &
