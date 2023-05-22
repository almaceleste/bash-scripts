#!/bin/bash

# open terminal with nyx to the tor service running on the router
# GNU Affero GPL 3.0 (ɔ) 2021,2022 almaceleste

# xfce4-terminal --title="nyx: mi-r3g" --command="nyx --interface 192.168.1.1:9140"

x-terminal-emulator -e bash -c "echo -ne '\033]2;nyx: mi-r3g\007'; nyx --interface 192.168.1.1:9140" &
