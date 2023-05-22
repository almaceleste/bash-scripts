#!/bin/bash

# open terminal with ssh connected to the router
# GNU Affero GPL 3.0 (ɔ) 2021,2022 almaceleste

# router='my.router'
router='192.168.1.1'

# xfce4-terminal --title="ssh: mi-r3g" --command="ssh curator@$router"

x-terminal-emulator -e bash -c "echo -ne '\033]2;ssh: mi-r3g\007'; ssh curator@$router" &
