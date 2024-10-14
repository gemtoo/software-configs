#!/bin/bash

if command -v dbus-launch >/dev/null && test -z "${DBUS_SESSION_BUS_ADDRESS}"; then
       eval $(dbus-launch --sh-syntax --exit-with-session)
fi

gentoo-pipewire-launcher &
sxhkd &
bash ~/scripts/xsetloop.sh &
picom --config ~/.config/picom.conf &
xset s off
xset -dpms
xmodmap -e "keycode 118 ="
xhost +local:docker
brightnessctl --device='intel_backlight' set 24242
brightnessctl --device='tpacpi::kbd_backlight' set 2
exec dwm
