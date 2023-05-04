#!/bin/bash

# search selection in google
# GNU Affero GPL 3.0 🄯 2019 almaceleste

selection=$(xclip -o)

# xfce4-terminal --hold --execute echo $selection

google-chrome --new-window "https://www.google.com/search?q=$selection"