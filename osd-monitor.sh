#!/bin/bash

# on-screen sensors monitor bash script
# (ɔ) almaceleste

SCR="$(basename "$0")"
LOCK="/tmp/$SCR.pid"
read -r PID < $LOCK

XOFFSET=25
YOFFSET=-1000
SIZE=15
LINEHEIGHT=$((SIZE + 5))
FONT="roboto $SIZE" 
FORECOLOR='cyan'
DELAY=1

# check if instance of script already is running
if [ -e ${LOCK} ] && kill -0 `cat ${LOCK}`; then
    # echo "already running"
    zenity --question --text="$SCR already was running.\nstop it?" --no-wrap --default-cancel
    if [ $? = 0 ]; then
        kill -s SIGKILL $PID
        zenity --question --text="do you want to start new instance\nof $SCR?" --no-wrap --default-cancel
        if [ $? = 1 ]; then
            rm -f ${LOCK}
            exit 0
        fi
    else
        exit 0
    fi
fi

# make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCK}; exit" INT TERM EXIT
echo $$ > ${LOCK}

# function for write messages in on-screen overlay 
function aosd() {
    OFFSET=$1
    # echo $((YOFFSET + OFFSET*LINEHEIGHT))
    aosd_cat --fade-in=1000 --fade-full=$((DELAY*1000)) --fade-out=1000 --font=$FONT --fore-color=$FORECOLOR --shadow-offset=1 --x-offset=$XOFFSET --y-offset=$((YOFFSET + OFFSET*LINEHEIGHT)) &
}

#do stuff
while :
do
    n=0
    time=$(date +%X) #+%H:%M)
    cpu_temp=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input)
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
    gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader)
    gpu_mem=$(nvidia-smi --query-gpu=utilization.memory --format=csv,noheader)
    ((n++)); echo time: ${time} | aosd $n
    ((n++)); echo cpu temp: ${cpu_temp::-3}°C | aosd $n
    ((n++)); echo gpu temp: $gpu_temp°C | aosd $n
    ((n++)); echo gpu usage: $gpu_usage | aosd $n
    ((n++)); echo gpu memory: $gpu_mem | aosd $n
    sleep $DELAY
done

# remove lockfile if something went wrong
rm -f ${LOCK}