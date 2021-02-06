#!/usr/bin/env bash

sleep 0.5

xsetwacom set 19 MapToOutput 1440x900+1366+0 
xsetwacom set 20 MapToOutput 1440x900+1366+0 
xsetwacom set 21 MapToOutput 1440x900+1366+0 

xsetwacom set 18 Button 9 "key f f"
xsetwacom set 18 Button 1 "key s"
xsetwacom set 18 Button 3 "key +super tab -super"
xsetwacom set 18 Button 8 "key c"
