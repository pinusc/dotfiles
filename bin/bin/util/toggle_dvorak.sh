#!/bin/bash

(setxkbmap -query | grep -q "layout:\s\+it") && setxkbmap -layout 'us(altgr-intl)' || setxkbmap it
xmodmap ~/.Xmodmap
