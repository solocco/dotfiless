# dbus-launch
#if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
#    eval `dbus-launch --sh-syntax --exit-with-session`
#fi

# dwm
#while true; do
#   /usr/bin/dwm 2> ~/.dwm.log
#done
#
exec dwm
