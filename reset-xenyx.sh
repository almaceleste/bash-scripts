#!/bin/bash

# reset usb device without detaching
# 1. create a custom sudoers file with the name 99-reset-xenyx by visudo (recommended):
# sudo visudo -f /etc/sudoers.d/99-reset-xenyx
# 2. add this script to the 99-reset-xenyx:
# # script to reset xenyx mixer
# alma	ALL= NOPASSWD:	/home/alma/Documents/scripts/reset-xenyx.sh
# 3. create desktop launcher with a command 'sudo /home/alma/Documents/scripts/reset-xenyx.sh'
# 4. restrict ownership of this script:
# sudo chown root:root /home/alma/Documents/scripts/reset-xenyx.sh
# 5. restrict permissions of this script:
# sudo chmod go-rwx /home/alma/Documents/scripts/reset-xenyx.sh
# (ɔ) 2019 almaceleste

USBDEVICE="/sys/bus/usb/devices/1-6/authorized"

echo 0 | sudo tee $USBDEVICE && echo 1 | sudo tee $USBDEVICE
