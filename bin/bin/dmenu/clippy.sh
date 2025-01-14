#!/usr/bin/env bash

if [[ "$1" = "-h" || "$1" = "--help" ]]; then
    cat<<EOF
    Usage: clippy.sh [search-term]
    It's clippy, man
EOF
fi

set -Eeuo pipefail
set -m  # job control

script_dir=$(dirname "$0")

makemessage() {
    local n
    local text
    n="$1"
    text="$2"
    if [ $((n % 2)) -eq 0 ]; then
        echo "textbox-$n { content: \"$text\"; border: 1px; border-radius: 8px; padding: 10px; margin: 1em 0 0 15em; expand: false; }"
    else
        echo "textbox-$n { content: \"$text\"; border: 1px; border-radius: 8px; padding: 10px; margin: 1em 15em 0 0; expand: false; }"
    fi
}

make_history() {
    local n
    local list
    local i
    n="$1"
    i=1
    list="["
    for i in $(seq 1 $((n-1))); do
        list="$list\"textbox-$i\","
    done
    list="$list\"textbox-$n\""
    list="$list]"
    echo "history { orientation: vertical; children: $list; }"

}

dmenu () {
    res="$(rofi -dmenu -sep '|' -format 'f' -theme "$script_dir/clippy.rasi" -theme-str "$(make_history "$nmess") $history")"
    ex="$?"
    echo "$res"
    return "$ex"
}

ai_run=0
ai_command () {
    if [ "$ai_run" -eq 0 ]; then
        aichat -s clippy --empty-session --save-session -m claude:claude-3-5-haiku-20241022 -r "clippy" "$1" | sed -z 's/\n/\\n/g'

    else
        aichat -s clippy --save-session -m claude:claude-3-5-haiku-20241022 -r "clippy" "$1" | sed -z 's/\n/\\n/g'
    fi
}

nmess=1
history="$(makemessage 1 "Hi, I'm Clippy. You look in trouble. Do you need any help?")"$'\n'
# history="$(makemessage 1 
while true; do
    q="$(dmenu)"
    if [ "$?" -eq 1 ]; then
        exit 0;
    fi
    nmess=$((nmess+1))
    history="$history $(makemessage "$nmess" "$q")"$'\n'
    nmess=$((nmess+1))
    history_backup="$history"
    wait_message="$(makemessage "$nmess" "... thinking ...")"$'\n'
    history="$history $wait_message"
    dmenu &
    answer="$(ai_command "$q")"
    kill %%
    history="$history_backup $(makemessage "$nmess" "$answer")"$'\n'
done
