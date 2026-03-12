#!/bin/bash

xsetwacom set "HID 256c:006d Pad pad" button 1 key Super Alt d; # draw mode
xsetwacom set "HID 256c:006d Pad pad" button 2 key Ctrl b;      # background
xsetwacom set "HID 256c:006d Pad pad" button 3 key Ctrl g;      # grid
xsetwacom set "HID 256c:006d Pad pad" button 8 key Super Alt e; # clear

xsetwacom set "HID 256c:006d Pad pad" button 9 key Ctrl 1;  # red
xsetwacom set "HID 256c:006d Pad pad" button 10 key Ctrl 2; # green
xsetwacom set "HID 256c:006d Pad pad" button 11 key Ctrl 4; # blue
xsetwacom set "HID 256c:006d Pad pad" button 12 key Ctrl z; # undo
