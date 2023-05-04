#!/bin/bash

# translate selection in google
# GNU Affero GPL 3.0 🄯 2019,2022 almaceleste
#
# dependencies:
# - xclip

selection=$(xclip -o)

# xfce4-terminal --hold --execute echo $selection

# xfce4-terminal --hold --execute trans -t ru "$selection"

x-terminal-emulator --hold -e trans -t ru "$selection"
