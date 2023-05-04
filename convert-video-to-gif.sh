#!/bin/bash

# convert video to gif
# GNU Affero GPL 3.0 🄯 2020 almaceleste

filename=$1
tmp=/tmp/frames
echo filename: $filename

echo 'create tmp folder'
mkdir "$tmp"

echo 'extract frmes from video'
ffmpeg -hide_banner -i "$1" "$tmp/frame%05d.png"

path="${filename%/*}"
if [ $path = $filename ]; then
    path='.'
fi
echo path: $path
filename="${filename##*/}"
echo filename: $filename
filename="${filename%.*}"
echo filename: $filename

echo 'convert frames to gif'
gm time convert -verbose -loop 0 "$tmp/frame*.png" "$tmp/$filename.gif"

echo 'copy gif to the target folder'
cp -f "$tmp/$filename.gif" "$path/"

echo 'delete tmp frames'
rm -r "$tmp"