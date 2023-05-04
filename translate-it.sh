#!/bin/bash

# translate selection in google-chrome
# GNU Affero GPL 3.0 🄯 2019 almaceleste
#
# dependencies:
# - xclip

selection=$(xclip -o)

# xfce4-terminal --hold --execute echo $selection

google-chrome --new-window "https://translate.google.com/?sl=auto&tl=ru&text=$selection"
