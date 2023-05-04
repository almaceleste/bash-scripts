#!/bin/bash

# open scrcpy connection to the mibox
# GNU Affero GPL 3.0 (ɔ) 2021 almaceleste

mibox="192.168.1.15:5555"

adb connect $mibox
scrcpy --disable-screensaver --stay-awake --hid-keyboard --serial $mibox
