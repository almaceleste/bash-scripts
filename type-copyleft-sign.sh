#!/bin/bash

# type copyleft sign
# GNU Affero GPL 3.0 🄯 2020 almaceleste

xdotool keyup Shift_L Shift_R Control_L Control_R Meta_L Meta_R Alt_L Alt_R Super_L Super_R Hyper_L Hyper_R ISO_Level2_Latch ISO_Level3_Shift ISO_Level3_Latch ISO_Level3_Lock ISO_Level5_Shift ISO_Level5_Latch ISO_Level5_Lock
xdotool getactivewindow type --clearmodifiers '🄯'
