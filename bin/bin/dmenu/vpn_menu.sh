#!/usr/bin/env bash

pattern="^cs-"
vpn_names="$(find /etc/wireguard -name 'cs-*'.conf -exec basename '{}' .conf \; | grep "$pattern")"
frequency_file="$XDG_CACHE_HOME/vpn_frequency"
[[ ! -f "$frequency_file" ]] && touch "$frequency_file"

vpn_names="$(cat "$frequency_file" <(echo "$vpn_names") | sort | uniq -c | sort -r | awk '{ print $2; }')"

has_interface () {
    ip link list | grep -E '^[[:digit:]]+' | cut -d: -f2 | tr -d ' ' | grep -e '^cs-'
}

if [[ -n "$(has_interface)" ]]; then
    echo "Interface exists"
    removeit="$(echo -e "Yes\nNo" | rofi -dmenu -p "A vpn connection exists already ($(has_interface)). Would you like to remove it?")"

    if [[ "$removeit" = Yes ]]; then
        sudo wg-quick down "$(has_interface)"
        if [[ -n "$(has_interface)" ]]; then
            echo "Critical error. Interface(s) not removed". >&2
        fi
    else
        exit 0
    fi
fi

selected=$(echo "$vpn_names" | rofi -dmenu)
if [[ -n "$selected" ]]; then
    sudo wg-quick up "$selected"
    echo "$selected" >> "$frequency_file"
fi
