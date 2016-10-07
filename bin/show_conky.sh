#!/usr/bin/bash

RUNNING=$(ps aux|grep -v awk|awk '/conky -c dotfiles\/conkyrc1/ {print $2}'|wc -w)
#FIFO=/tmp/PUSHBULLET
#TOKEN="mJpoW4ScJsBPMJcntjuJ4cNMfPICwZty"
#URL="wss://stream.pushbullet.com/websocket/"

#if [ -p $FIFO ]; then
#		rm $FIFO
#fi

if [ $RUNNING -ne "0" ]; then
	#killall conky
  kill $(ps aux|grep -v awk|awk '/conky -c dotfiles\/conkyrc1/ {print $2}')
  pkill stalonetray
  bspc config right_padding 0
else
  # bspc query returns the number of monitors
  # since the rightmost monitor is the last one
  # this assures conky is always on the rightmost
  bspc config -m $(bspc query -M | tail -c 2) right_padding 143
  conky -c dotfiles/conkyrc1 &> /dev/null
  stalonetray &
fi
