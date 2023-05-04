#!/bin/bash

# duplicate file in-place
# GNU GPL 3.0 🄯 2021 almaceleste

fullname=$1
filepath=$(dirname "$fullname")
filename=$(basename "$fullname")
extension=''
suffix='#'
index=1

if [[ $filename == *.* ]]; then
    extension="${filename##*.}"
    if [[ $extension == #* ]]; then
        extension = ''
    else
        extension = ".$extension"
    fi
fi

filename="${filename%.*}"

cp "$fullname" "$filepath/$filename.$suffix$index$extension"