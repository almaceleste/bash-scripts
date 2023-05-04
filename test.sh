#!/bin/bash

# tmp script for testing purposes
# GNU Affero GPL 3.0 (ɔ) 2020 almaceleste

declare -A args

case $@ in
    '') echo '1:this is empty arg'
        read -r -d '' prompt << EOM
┌──────────────────────────
│ ⚠️ do you want to create a service that will unset grub recordfail option when the computer
│   goes into hibernate mode (this prevents the grub boot menu from appearing on boot after
│   hibernation)? (yes/no)
EOM
        while true; do
        read -p "$prompt " answer
            case $answer in
                [Yy]* ) echo "│ ⚠️ you answered '$answer'"; break;;
                [Nn]* ) echo "│ ⚠️ you answered '$answer'"; exit;;
                * ) echo "│ ⚠️ you answered '$answer'. please answer yes or no.";;
            esac
        done
    ;;
    *)
        for arg in $@; do
            IFS='=' read -r key value <<< $arg
            args+=([$key]=$value)
            echo "key:$key value:$value"
        done
    ;;
esac
function print-help(){
    read -r -d '' help << EOM
usage:  display-off.sh [option]
turn off/on a display (one in multihead setup or all in the system)

options:
    --all      turn off/on the displays of the all monitors
    --help     show this help and exit
    --version  show version info and exit
    <output>   turn off/on the display of the individual monitor, connected to the <output>

you could get the <output> by 'xrandr --query' command. 
usually it looks like smth as HDMI-0 or DP-1

repo: <https://github.com/almaceleste/display-off>
EOM
    echo "$help"
}
function print(){
    echo $#: $1 $2
}
for key in ${!args[@]}; do
    case $key in
        --help)
            print-help
            exit
        ;;
        --hola) echo "hola, ${args[$key]}"
        ;;
        --test) echo "this is a ${args[$key]}"
        ;;
        --path) cat ${args[$key]}
        ;;
        '') echo '2:this is empty arg'
        ;;
        *)
            print $value $key
        # echo "$key: $value"
        ;;
    esac
done
