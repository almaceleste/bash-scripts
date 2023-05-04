#!/bin/bash

# kill chrome audio service to restore lost sound
# (ɔ) 2022 almaceleste

pkill -f chrome.*--type=gpu-process