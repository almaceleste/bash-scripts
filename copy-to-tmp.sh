#!/bin/bash

# create a folder with source folder name in /tmp and copy there the file from path passed in the argument
# supports smb: protocol as well
# GNU Affero GPL 3.0 🄯 2022 almaceleste

dir="/tmp"

path="$*"

dir="$dir/$(basename $(dirname "$path"))"
# filename=$(basename "$path")
mkdir --parents "$dir"

if [[ $path == smb:* ]]; then
    smb=$(dirname "$path")
    gio mount --anonymous "$smb"
    gio copy "$path" "$dir"
    gio mount --unmount "$smb"
    # url=$(node -e "const url=require('/usr/share/nodejs/encodeurl')('$path'); console.log(url);")
    # curl --user anonymous:anonymous --output "$dir/$filename" "$url"
else
    cp "$path" "$dir"
fi

exit 0