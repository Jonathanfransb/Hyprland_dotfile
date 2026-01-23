#!/usr/bin/env bash

SHUTDOWN=" Shutdown"
REBOOT="󰑐 Reboot"
SUSPEND="󰒲 Suspend"
LOGOUT="󰍃 Logout"

ROFI=$(echo -e "$SHUTDOWN\n""$REBOOT\n""$SUSPEND\n""$LOGOUT" | rofi -dmenu)

case $ROFI in 
	$SHUTDOWN)
		systemctl poweroff
		;;
	$REBOOT)
		systemctl reboot
		;;
	$SUSPEND)
		systemctl suspend
		;;
	$LOGOUT)
		hyprctl dispatch exit
		;;
esac
