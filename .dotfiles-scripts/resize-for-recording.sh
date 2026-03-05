#!/bin/bash

wmctrl -r :ACTIVE: -b remove,sticky
wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz

# wmctrl -l -x 
# Shows windows width identifier, add keywords to list below for exceptions
specialWindows=(terminal eog evince gedit nautilus control-center maoschanz.drawing)
found=false
shopt -s nocasematch
activeWindowClass=`xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5) WM_CLASS`

for specialWindowClass in "${specialWindows[@]}"
do
	[[ $activeWindowClass =~ $specialWindowClass ]] && found=true
done

x=`xrandr | grep -w HDMI-0 | awk -F "[ x]" '{ print $3 }'`
y=0
width=2290
height=1075

if [ $found = true ] 
then
	((x-=39))
	((y-=7))
	((width+=78))
	((height+=104))	
fi

wmctrl -r :ACTIVE: -e 0,$x,$y,$width,$height
