#!/bin/bash

# open clipboard (or selection) in chrome as url
# GNU Affero GPL 3.0 🄯 2021 almaceleste

selection=$(xclip -o -selection clipboard)

if [[ ! $selection ]]; then
    selection=$(xclip -o)
fi

# xfce4-terminal --hold --execute echo $selection

google-chrome --new-window $selection