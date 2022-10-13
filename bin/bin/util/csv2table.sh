#!/bin/bash

# simple program using column and awk to format and pretty print a csv table

IFS='' read -r -d '' AWKCODE <<EOF
(NR == 1) {
    orig = \$0;
    top_header = \$0;
    gsub("[^│]", "━", top_header);
    gsub("│", "┯", top_header);
    print "┏━" top_header "━┓";
    print "┃ " orig " ┃" ;
    gsub("[^│]", "━");
    gsub("│", "┿");
    print "┣━" \$0 "━┫" ;
}
(NR != 1) {
    if (NR % 3 == 2 && color)
        print "┃ \033[36m" \$0 "\033[0m ┃";
    else 
        print "┃ " \$0 " ┃";
}

END {
    bottom_header = orig;
    gsub("[^│]", "━", bottom_header);
    gsub("│", "┷", bottom_header);
    print "┗━" bottom_header "━┛";
}
EOF

IFS='' read -r -d '' AWKCODE2 <<EOF
{
    if (NR > 1 && NR % 3 == 0)
        print "\033[30;47m" \$0 "\033[0m";
    else
        print \$0;
}
EOF

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo Usage: csv2table.sh FILE
    exit 0
fi
if [[ "$1" == "-C" || "$1" == "--no-color" ]]; then
    color=0
    shift
elif [ -n "${NO_COLOR+x}" ]; then
    color=0
else
    color=1
fi

if [[ -n "$1" ]]; then
    fname="$1"
fi
sed 's/$/,/' | column -t -R'0' -s, -o$' │ ' ${1:+"$fname"} | sed 's/ │ $//' | awk -v color="$color" "$AWKCODE" | less -SR
