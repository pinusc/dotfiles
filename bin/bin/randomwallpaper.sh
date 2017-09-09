#!/bin/sh
WALLPAPERS="/home/pinusc/.wallpaper"
ALIST=( `ls -w 1 $WALLPAPERS` )
RANGE=${#ALIST[*]}
SHOW=$(( $RANDOM % $RANGE ))
#DISPLAY=:0.0 feh --bg-fill $WALLPAPERS/${ALIST[$SHOW]}
echo "1"
export DISPLAY=:0.0
DISPLAY=:0 /bin/feh --recursive --randomize --bg-fill /home/pinusc/.wallpaper
echo "lol" >> /home/pinusc/cron1.txt
#feh --recursive --randomize --bg-fill /home/pinusc/.wallpaper
#/bin/bash -c 'ln -s $(find /home/pinusc/.wallpaper | sort -R | head -n 1) /tmp/wallpaper'
