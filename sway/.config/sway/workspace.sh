#!/bin/sh

CUR_WORKSPACE=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused)' | jq -r '.current_workspace')

if [ $1 == "prev" ]; then
    TO_WORKSPACE=$(expr $CUR_WORKSPACE - 1)
elif [ $1 == "next" ]; then
    TO_WORKSPACE=$(expr $CUR_WORKSPACE + 1)
elif [ $1 == "sov" ]; then
    echo 1 > /tmp/sovpipe
    sleep 1
    echo 0 > /tmp/sovpipe
    exit # vital
fi

if [ $TO_WORKSPACE -eq 11 ]; then
    TO_WORKSPACE=1
elif [ $TO_WORKSPACE -eq 0 ]; then
    TO_WORKSPACE=10
fi

swaymsg workspace number $TO_WORKSPACE
