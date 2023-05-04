#!/bin/bash

# kill all zombie processes
# (ɔ) almaceleste

kill $(ps -A -ostat,ppid | awk '/[zZ]/ && !a[$2]++ {print $2}')