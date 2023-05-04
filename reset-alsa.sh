#!/bin/bash

# restart alsa service
# 1. create a custom sudoers file with the name 99-restart-alsa by visudo (recommended):
# sudo visudo -f /etc/sudoers.d/99-restart-alsa
# 2. add this script to the 99-restart-alsa:
# # script to reset alsa service
# alma	ALL= NOPASSWD:	/home/alma/Documents/scripts/restart-alsa.sh
# 3. create desktop launcher with a command 'sudo /home/alma/Documents/scripts/restart-alsa.sh'
# 4. restrict ownership of this script:
# sudo chown root:root /home/alma/Documents/scripts/restart-alsa.sh
# 5. restrict permissions of this script:
# sudo chmod go-rwx /home/alma/Documents/scripts/restart-alsa.sh
# (ɔ) 2019 almaceleste

sudo /etc/init.d/alsa-utils stop
sudo alsa force-reload
sudo /etc/init.d/alsa-utils start
