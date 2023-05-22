#!/bin/bash

# mount router storage
# GNU Affero GPL 3.0 (ɔ) 2021,2022 almaceleste

mountpoint='/tmp/my.router/'
router='my.router'
username='curator'

# create mount point
if [ ! -d $mountpoint ]; then
    mkdir $mountpoint
fi

# unmount previous session
if [[ $(ps aux | grep -i sftp | grep -i $username@$router) ]]; then
    fusermount -u $mountpoint
fi

# mount router fs by ssh
sshfs -o password_stdin $username@$router:/ "$mountpoint" <<< 'password'

# open mounted point with file manager
thunar $mountpoint