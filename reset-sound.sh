#!/bin/bash

# restart pulseaudio service, alsa and reset xenyx device
# (ɔ) 2021 almaceleste

scriptsdir="/home/alma/repo/scripts"

sudo $scriptsdir/reset-xenyx.sh
$scriptsdir/reset-pulse.sh
sudo $scriptsdir/reset-alsa.sh
