#!/usr/bin/env bash

sleep 0.5
url=$(ssh weechat 'cat ~/url.txt')
echo "$url"

if [[ "$url" == emxc://* ]]; then
    newurl="$(matrix_decrypt --plumber echo "$url")"
    echo "new_url: $newurl"
    rifle "$newurl"
    exit 0
fi

rifle "$url"
