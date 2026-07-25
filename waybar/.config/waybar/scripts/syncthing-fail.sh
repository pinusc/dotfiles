#!/usr/bin/env sh

API_KEY="$(< "$XDG_DATA_HOME/SYNCTHING_API_KEY")"
SYNCTHING_URL="127.0.0.1:8384"

failed_files="$(curl --silent -H "X-API-Key: $API_KEY" "$SYNCTHING_URL/rest/config/folders" | jq -r '.[] | .path' | sed "s|^\~|$HOME|" | xargs -I{} find "{}" -name '*sync-conflict*')"

nfiles="$(echo "$failed_files" | wc -l)"

if [ "$nfiles" -gt 1 ]; then
    class="error"
else
    nfiles=""
    class="success"
fi

echo "{}" | jq --unbuffered --compact-output "{text: \"$nfiles\", alt:\"$failed_files\", class: \"$class\"}"
