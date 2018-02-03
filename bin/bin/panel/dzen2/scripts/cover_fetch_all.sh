#!/bin/bash

# CALL ME FROM ~/.cache/covers OR DEAL WITH MOVING THEM!
# Otherwise fully automated :)

x=$(mpc -f "%artist%\t%album%@" listall | uniq )
IFS=$'@' 
for line in $x; do
    l=$(echo -n $line)
    IFS=$'\t' read -d$'@' a b <<<"$l"
    a=$(echo $a | tr -d '\n')
    b=$(echo $b | tr -d '\n')
    ./cover_fetcher "$a" "$b" &
done
