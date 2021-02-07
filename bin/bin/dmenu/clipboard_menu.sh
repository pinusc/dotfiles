#!/bin/zsh
export CM_LAUNCHER=rofi

if [[ "$1" = "--type" ]]; then
    export CM_OUTPUT_CLIP=1
fi
out=$(clipmenu -p "clip")
xdotool type --clearmodifiers "$out"
