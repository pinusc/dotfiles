#!/usr/bin/env bash

# Utility to download content at an url and open it with nuke

URL="$1"
TMPDIR="$(mktemp -d "/tmp/$USER/XXXX-urlopen")"
(cd "$TMPDIR" && wget --content-disposition --trust-server-names "$URL")
set "$TMPDIR/"*
nuke "$1"
