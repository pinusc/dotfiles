#!/usr/bin/env sh

# rofi -recursivebrowser-command dragon-drop -show recursivebrowser 2>/dev/null
fd --follow -X ls -dt | rofi -dmenu | dragon-drop --stdin
