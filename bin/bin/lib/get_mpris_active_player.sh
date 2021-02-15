#!/usr/bin/env bash

CACHEFILE="$XDG_CACHE_HOME/mpris-active-player.dat"

# A simple script to get "active player" out of playerctl
for player in $(playerctl --list-all); do
    if [[ "$(playerctl -p "$player" status)" = "Playing" ]]; then
        echo "$player"
        echo "$player" > "$CACHEFILE"
        exit 0
    fi
done
# only runs if nothing playing found
if [[ -f "$CACHEFILE" ]]; then
    if playerctl --list-all | grep -q "$(< "$CACHEFILE")"; then
        cat "$CACHEFILE"
    fi
elif playerctl --list-all | grep -q mpd; then
    echo "mpd"
else
    playerctl --list-all | head -n 1
fi
