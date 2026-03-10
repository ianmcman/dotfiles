#!/bin/bash

# Power menu script
choice=$(echo -e "Logout\nReboot\nShutdown\nLock" | rofi -dmenu -p "Power Menu" -theme-str 'window {width: 20%;} listview {lines: 4;}')

case "$choice" in
    Logout)
        hyprctl dispatch exit
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
    Lock)
        hyprlock
        ;;
esac
