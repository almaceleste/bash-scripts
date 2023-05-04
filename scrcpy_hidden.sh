#!/bin/bash

# scrcpy daemon bash script
# (ɔ) almaceleste


# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# exec 1>scrcpy.log 2>&1

SCR="$(basename "$0")"
LOCK="/tmp/$SCR.pid"
DIR="$(dirname "$(readlink -f "$0")")"
LOG="$DIR/$SCR.log"
read -r PID < $LOCK
# echo 'process = ' $SCR > $LOG
# echo 'pid = ' $PID >> $LOG

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

# do stuff
while :
do
    adb wait-for-device
    # xdotool search --name '^scrcpy$' windowclose
    scrcpy --no-control
    # xdotool search --sync --class "scrcpy" windowsize 100% 100%
    # WIN=$(xdotool search --sync --class "scrcpy" getwindowname)
    # echo 'win = ' $WIN >> $LOG
    # sleep 1
    # wmctrl -F -r "scrcpy" -b add,above #,skip_taskbar
    # wmctrl -F -r "${WIN}" -b add,below
    # until [ -z "$(pidof scrcpy)" ]; do
    #     sleep 1
    # done
done

rm -f ${LOCK}