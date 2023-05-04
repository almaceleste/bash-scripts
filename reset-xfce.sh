#!/bin/bash

# reload xfce4 settings
# GNU GPL 3.0 🄯 2021 almaceleste

killall xfconfd
/usr/lib/x86_64-linux-gnu/xfce4/xfconf/xfconfd &
xfsettingsd --replace &
