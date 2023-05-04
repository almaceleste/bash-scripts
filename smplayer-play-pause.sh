#!/bin/bash

# send to smplayer command to play or pause
# GNU Affero GPL 3.0 (ɔ) 2020 almaceleste

# dependencies:
#   xdotool

window=$(xdotool getactivewindow)

smplayer -send-action 'play_or_pause'
xdotool windowactivate $window