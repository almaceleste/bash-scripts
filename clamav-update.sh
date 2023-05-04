#!/bin/bash

# update clamAV virus signatures
# GNU Affero GPL 3.0 🄯 2023 almaceleste

mkdir /tmp/clamav
curl --socks5 192.168.1.1:9050 --output /tmp/clamav/main.cvd http://database.clamav.net/main.cvd
sudo cp /tmp/clamav/main.cvd /var/lib/clamav/
sudo chown clamav:clamav /var/lib/clamav/main.cvd
sudo chmod 644 /var/lib/clamav/main.cvd