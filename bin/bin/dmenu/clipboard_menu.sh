#!/bin/zsh
source ~/.dmenurc
clipmenu $(echo "$dmenu_command -b -l 16" | tail -c +23)
