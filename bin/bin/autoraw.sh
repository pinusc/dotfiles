#!/bin/bash
FORMAT1="NEF"
FORMAT2="JPG"
files=`ls *.$FORMAT1`

for f in *.$FORMAT1; do
    # echo 1
    fconverted="`echo $f | head -c -4`$FORMAT2"
    # echo "$fconverted"
    if [[ -f "$fconverted" ]]; then
        # echo $f
        # echo 2
        rm "$f"
    fi
done
