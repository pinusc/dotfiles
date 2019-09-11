#!/bin/bash

xrandr --verbose | awk '
/[:.]/ && hex {
    sub(/.*000000fc00/, "", hex)
    hex = substr(hex, 0, 26) "0a"
    sub(/0a.*/, "0a", hex)
    print hex
    hex=""
}
hex {
    gsub(/[ \t]+/, "")
    hex = hex $0
}
/EDID.*:/ {
    hex=" "
}' | xxd -r -p

# xrandr --newmode "1366x768"x0.0   69.30  1366 1404 1426 1436  768 771 777 803 -hsync -vsync
