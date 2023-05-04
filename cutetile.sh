#!/bin/bash

# cute tile script for tiling windows to the desktop edge by steps
# GNU Affero GPL 3.0 🄯 2020 almaceleste

# dependencies:
#   xdotool
#   xdpyinfo
#   xprop
#   xrandr

# set direction of tiling (first argument): left right top bottom
direction=$1
echo $direction
# set amount of steps of tiling (if the window can produce this steps)
steps=3

declare -A display displays docks frame hints screen struts window

# get active window parameters: id
# if the script has second argument this is window id
if [ $2 ]; then
    window[ID]=$2
else
    window[ID]=$(xdotool getactivewindow)    
fi

# get screen (area of workspace) size
screenProps=$(xrandr --query | awk -F', ' '/Screen/ {print $2}' | awk '{print $2 $3 $4}')
# echo $screenProps
IFS='x' read -r screen[WIDTH] screen[HEIGHT] <<< $screenProps
# echo ${screen[WIDTH]} ${screen[HEIGHT]}

# get screen (area of workspace) size (alternative)
# screenDimensions=$(xdpyinfo | awk '/dimensions:/ {printf $2}')
# IFS='x' read -r screen[WIDTH] screen[HEIGHT] <<< $screenDimensions
# echo ${screen[WIDTH]} ${screen[HEIGHT]}

# get active window size hints properties
hintsProps=$(xprop -id ${window[ID]} WM_NORMAL_HINTS | grep 'program specified minimum size:' | awk -F': ' '{print $2}')
IFS=' ' read -r hints[WIDTH] garbage hints[HEIGHT] <<< $hintsProps
# echo :${hints[WIDTH]}:${hints[HEIGHT]}:

# get active window frame properties
frameProps=$(xprop -id ${window[ID]} _NET_FRAME_EXTENTS | awk -F'= ' '/_NET_FRAME_EXTENTS/ {print $2}')
IFS=', ' read -r frame[LEFT] frame[RIGHT] frame[TOP] frame[BOTTOM] <<< $frameProps
# echo :${frame[LEFT]}:${frame[RIGHT]}:${frame[TOP]}:${frame[BOTTOM]}:

# get displays properties
displaysProps=$(xrandr --query | grep -oP ' connected.*\s\K\d+x\d+\+\d+\+\d+')
while IFS=' ' read -r display; do 
    IFS='+' read -r dimension offset <<< $display
    displays+=([$offset]=$dimension)
done <<< $displaysProps
# echo ${!displays[@]}
# echo ${displays[@]}

# get active window maximized properties
if [ "$(xprop -id ${window[ID]} _NET_WM_STATE | grep '_NET_WM_STATE_MAXIMIZED_HORZ')" ]; then
    window[MAX]='maximized_horz'
fi
if [ "$(xprop -id ${window[ID]} _NET_WM_STATE | grep '_NET_WM_STATE_MAXIMIZED_VERT')" ]; then
    ((window[MAX]+='maximized_vert'))
fi
echo ${window[MAX]}
# unmaximize window to operate with original window dimensions
wmctrl -ir ${window[ID]} -b remove,maximized_vert,maximized_horz

# get active window parameters: coordinates (X and Y) and size (WIDTH and HEIGHT)
while IFS='=' read -r name value; do 
    window+=([$name]=$value)
done <<< $(xdotool getwindowgeometry --shell ${window[ID]})
# echo ${window[WINDOW]} ${window[X]} ${window[Y]} ${window[WIDTH]} ${window[HEIGHT]}

# temporary restore active window maximized properties
wmctrl -ir ${window[ID]} -b add,${window[MAX]}

for key in ${!displays[@]}; do
    # get display offset relative to the screen left-top corner
    IFS='+' read -r display[X] display[Y] <<< $key
    # get display size
    IFS='x' read -r display[WIDTH] display[HEIGHT] <<< ${displays[$key]}
    # echo ${display[X]} ${display[Y]} ${display[WIDTH]} ${display[HEIGHT]}
    if ((${window[Y]} >= ${display[Y]})) && (((${window[Y]} - ${display[Y]}) < ${display[HEIGHT]})); then
        if ((${window[X]} >= ${display[X]})) && (((${window[X]} - ${display[X]}) < ${display[WIDTH]})); then
            # get the negative display offsets from the screen right-bottom corner
            ((display[-X]=${screen[WIDTH]}-${display[WIDTH]}))
            ((display[-Y]=${screen[HEIGHT]}-${display[HEIGHT]}))
            break
        fi
    fi
done
# echo ${display[X]} ${display[Y]}

height=${window[HEIGHT]}
if [ $direction ]
then
    case $direction in 
        left | right)
            # calculate current step
            ((step=${display[WIDTH]}/${window[WIDTH]}))
            # echo $step
            # if current step is greater than steps limit then reset it to first
            if [ $step -gt $steps ]; then
                step=1
            fi
            # echo $step:$steps
            # calculate next step
            ((step++))
            # echo $step:$steps
            # calculate window width without horizontal frames
            ((width=${display[WIDTH]}/$step-${frame[LEFT]}-${frame[RIGHT]}))
            # if calculated width is lighter than minimal window width reset step and recalculate width
            if [ $width -lt ${hints[WIDTH]} ]; then
                step=1
                ((step++))
                ((width=${display[WIDTH]}/$step-${frame[LEFT]}-${frame[RIGHT]}))
            fi
            # calculate window height without vertical frames
            # ((height=${display[HEIGHT]}-${frame[TOP]}-${frame[BOTTOM]}))

            # calculate new coordinates of window with display offset
            ((x=${display[X]}+0))
            ((y=${display[Y]}+0))
            # if direction is right shift x to the right on difference of display width and window width
            if [ $direction == 'right' ]; then
                ((x+=${display[WIDTH]}-$width))
            fi
            ;;
        top)
            ;;
        bottom)
            ;;
    esac
    echo $x $y $width $height

    # get additional offsets cause the space is reserved by docks
    # search dock windows ids
    dockIDs=$(xdotool search --class xfce4-panel)
    for dockID in $dockIDs; do
        if [ ! -z "$(xprop -id $dockID _NET_WM_WINDOW_TYPE | grep 'DOCK')" ]; then
            IFS='= ' read -r garbage strutProps <<< $(xprop -id $dockID _NET_WM_STRUT_PARTIAL)
            # echo $strutProps
            #  get offsets and struts of the dock (the variables taken similar to the freedesktop documentation https://specifications.freedesktop.org/wm-spec/1.3/ar01s05.html)
            IFS=', ' read -r docks[left] docks[right] docks[top] docks[bottom] struts[left_start] struts[left_end] struts[right_start] struts[right_end] struts[top_start] struts[top_end] struts[bottom_start] struts[bottom_end] <<< $strutProps
            # get the nonzero offsets
            for dock in ${!docks[@]}; do
                if ((${docks[$dock]} > 0)); then
                    # echo $dock ${docks[$dock]} ${struts[$dock'_start']} ${struts[$dock'_end']}
                    # get the coordinates and size of the dock
                    # check if the dock is placed on the same display as well as the window
                    case $dock in
                        top)
                            ((dockY=${docks[$dock]}))
                            if (($dockY > ${display[Y]})) && ((($dockY - ${display[Y]}) < ${display[HEIGHT]})); then
                                echo $dock ${docks[$dock]} ${struts[$dock'_start']} ${struts[$dock'_end']}
                                if ((${struts[$dock'_start']} >= ${display[X]})) && (((${struts[$dock'_end']} - ${display[X]}) < ${display[WIDTH]})); then
                                    # ((height-=${docks[$dock]}-${display[Y]}))
                                    ((y+=${docks[$dock]}-${display[Y]}))
                                    break
                                fi
                            fi
                            ;;
                        bottom)
                            ((dockY=${screen[HEIGHT]}-${docks[$dock]}))
                            if (($dockY > ${display[Y]})) && ((($dockY - ${display[Y]}) < ${display[HEIGHT]})); then
                                echo $dock ${docks[$dock]} ${struts[$dock'_start']} ${struts[$dock'_end']} ${display[X]} ${display[Y]} ${display[WIDTH]} ${display[HEIGHT]}
                                if ((${struts[$dock'_start']} >= ${display[X]})) && (((${struts[$dock'_end']} - ${display[X]}) < ${display[WIDTH]})); then
                                    # ((height-=${docks[$dock]}-${display[-Y]}))
                                    echo $x $y $width $height
                                    break
                                fi
                            fi
                            ;;
                    esac
                fi
            done
        fi
    done

    echo ${window[ID]}
    # move and resize window
    xdotool windowmove ${window[ID]} $x $y
    xdotool windowsize ${window[ID]} $width $height
    wmctrl -ir ${window[ID]} -b add,maximized_vert
    # wmctrl -i -r ${window[ID]} -e 0,$x,$y,$width,$height
fi
