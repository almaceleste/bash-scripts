#!/bin/bash

# move mouse to next monitor
# GNU Affero GPL 3.0 (ɔ) 2020 almaceleste

window="xfce4-popup-whiskermenu"

# xdotool exec --sync $window
# xdotool search --class $window  windowactivate --sync 
# xdotool mousemove 50 500 --window $window

xdotool keydown alt key Tab #--window $window
sleep 2
xdotool keyup alt