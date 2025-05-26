#!/bin/sh

$HOME/suckless/dwm/status/dwmstatus &

feh --bg-scale /home/cid/suckless/wall/wall_1.jpg &

$HOME/suckless/dwm/scripts/comp &

xrdb merge /home/cid/xresources && kill -USR1 $(pidof st)
