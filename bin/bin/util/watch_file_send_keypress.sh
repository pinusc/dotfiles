#!/usr/bin/env bash

IFS='' read -r -d '' helpstring <<EOF
watch_file_send_keypress.sh - watches a file and sends a keypress to selected window.

USAGE: 
watch_file_send_keypress.sh FILE KEY_SEQUENCE [WID]

If the WID is not provided, you will be able to click on a window to select it.
EOF

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$helpstring"
fi

file="$1"
keys="$2"
wid="$3"

if [ -z "$wid" ]; then
    echo "Click on a window to select it"
    wid="$(xdotool selectwindow)"
    echo "Got it!"
fi

watch_file_and_do() {
    while true; do 
        inotifywait -e close_write "$file" &>/dev/null
        echo "Got an event!"
        xdotool key --window "$wid" "$keys"
    done
}

watch_file_and_do &
echo "Watching $file for changes..."
echo "Press any key to stop!"
read -n 1
echo "Thanks for running"


kill %%
exit 0
