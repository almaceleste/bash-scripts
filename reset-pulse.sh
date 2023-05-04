#!/bin/bash

# restart pulseaudio service
# (ɔ) 2019 almaceleste

pulseaudio --kill
sleep 1
if [ $(systemctl --user status pulseaudio.service | grep "Active:" | awk '{print $2}') = 'failed' ]
then
    pulseaudio --start
    sleep 1
fi