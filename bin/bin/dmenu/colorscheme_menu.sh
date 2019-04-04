#! /bin/bash

path="$HOME/.config/base16-shell/scripts/"


find $path -type f -printf "%f\n" | xargs -I_ basename _ .sh | rofi -dmenu | sed 's/base16-//' | xargs colorscheme
