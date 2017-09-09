#!/bin/bash

(setxkbmap -query | grep -q "layout:\s\+it") && setxkbmap us || setxkbmap it;
xmodmap ~/.Xmodmap
