#!/bin/bash
# Kill already running process
_ps=(waybar mako)
for _prs in "${_ps[@]}"; do
	if [[ `pidof ${_prs}` ]]; then
		killall -9 ${_prs}
	fi
done

if ! pgrep -x "polkit-gnome-authentication-agent-1" >/dev/null; then
    /usr/libexec/polkit-gnome-authentication-agent-1 &
fi

#xrdb merge /home/cid/xresources && kill -USR1 $(pidof st) &

wlsunset -T 6500 -t 5500 -l -6.2 -L 106.8 -d 3 &

# Set wallpaper
~/.config/niri/scripts/wallpaper &

~/.config/niri/scripts/swww.sh &

# Apply themes
~/.config/niri/scripts/gtkthemes &

# Lauch notification daemon (mako)
notif &

# Lauch statusbar (waybar)
launch-waybar.sh &

#pipewire &
#swww init &
xwayland-satellite &
#eww open ba

## User Friendly Network Menu
nm-applet --indicator &

## User Friendly Bluetooth Menu
blueman-applet &
