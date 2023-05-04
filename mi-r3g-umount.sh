#!/bin/bash

# unmount router storage
# GNU Affero GPL 3.0 (ɔ) 2021,2022 almaceleste

mountpoint='/tmp/my.router/'
router='my.router'
username='curator'

# unmount previous session
if [[ $(ps aux | grep -i sftp | grep -i $username@$router) ]]; then
    fusermount -u $mountpoint
fi
