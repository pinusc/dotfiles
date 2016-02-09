#!/bin/bash

(setxkbmap -query | grep -q "layout:\s\+it") && setxkbmap dvorak || setxkbmap it
