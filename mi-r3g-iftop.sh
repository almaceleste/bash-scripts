#!/bin/bash

# open terminal with ssh connected to the router and
# run iftop to monitor connections
# GNU Affero GPL 3.0 (ɔ) 2021,2022 almaceleste

# router='my.router'
router='192.168.1.1'

# xfce4-terminal --title="ssh: mi-r3g - iftop" --command="ssh -t curator@$router '/opt/bin/iftop -P -i br0 -F 192.168.1.0/24;sh -i'"

x-terminal-emulator -e bash -c "echo -ne '\033]2;ssh: mi-r3g - iftop\007'; ssh -t curator@$router '/opt/bin/iftop -P -i br0 -F 192.168.1.0/24;sh -i'"
