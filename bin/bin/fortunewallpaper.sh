#1/bin/zsh
color=$(hexdump -n 3 -v -e '"#" 3/1 "%02X" "\n"' /dev/urandom); convert -background $color -size 1920x1080 -gravity Center -family "Georgia" -border 70 -bordercolor $color caption:"$(fortune -as | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' | tr -d '\t' | sed s/--/—/g)" /tmp/back.png && feh --bg-fill /tmp/back.png
