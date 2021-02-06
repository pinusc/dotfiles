#!/bin/bash

BROWSER="$HOME/dev/qutebrowser/.venv/bin/qutebrowser"

filename="$1"
tmpfile="$(mktemp -u /tmp/mutt-preview-XXXX.html)"
cp "$filename" "$tmpfile"
"$BROWSER" "file://$tmpfile" >/dev/null 2>&1 &
