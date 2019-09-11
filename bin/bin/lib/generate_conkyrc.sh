#!/bin/bash
source ~/bin/lib/colors.sh

text=""
n='
'
for i in $( seq 0 15 );
do
    hex=$( printf "0%X" $i )
    eval bhex=\${base${hex}}
    bname=base$hex
    text="$text\n#define $bname $bhex"
done
echo -e $text

echo -e $text | cat - $HOME/.conkyrc.def | cpp -P - -o $HOME/.conkyrc
