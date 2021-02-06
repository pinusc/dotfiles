#!/usr/bin/env bash

[[ -z "$TEMPLATE_DIR" ]] && TEMPLATE_DIR="$HOME/.templates"
if [[ ! ( -d "$TEMPLATE_DIR" ) ]]; then
    echo "$TEMPLATE_DIR does not exist!"
    exit 1
fi

templates=$(find "$TEMPLATE_DIR" -maxdepth 1 -mindepth 1)

echo "$templates"
