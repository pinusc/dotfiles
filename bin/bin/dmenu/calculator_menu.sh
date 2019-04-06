#!/bin/sh
source ~/.dmenurc
xsel -o | $dmenu_command -p "         Calculate": | xargs echo | bc 2>&1 | $dmenu_command -p "          Answer: " | xsel -i
