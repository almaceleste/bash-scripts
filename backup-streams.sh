#!/bin/bash

# backup streams to smb share bash script
# (ɔ) almaceleste

title="completed"
destination='smb://ix2-ng/streams/'
source='/home/alma/Videos/obs-studio/streams/'
number=3
# files=$(find $source -type f -mtime +7 -print0 | sort -z | head -z --lines=$number | xargs -0)
# files=$(find $source -type f -mtime +7 | sort | head --lines=$number)

gio mount $destination < /home/alma/.ix2-ng_streams

# IFS=\n
# for file in $files
find $source -type f -mtime +7 -print0 | sort -z | head -z --lines=$number | 
while IFS= read -r -d '' file
do
    # echo $file
    xfce4-terminal --dynamic-title-mode=replace --title="$file" --initial-title=$title --command="gio move --progress \"$file\" $destination" && wait
    # echo -------
done
