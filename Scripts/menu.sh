#!/usr/bin/bash

ENTRY1="󰵆  Apps"
ENTRY2="  Bluetooth"
ENTRY3="󰐥  Power"
ENTRY4="󰋩  Wallpaper"
ENTRY5="  Clipboard"
ENTRY6="󰵝  Capture"
ENTRY7="  Nightlight"

ROFI=$(echo -e "$ENTRY1\n""$ENTRY2\n""$ENTRY3\n""$ENTRY4\n""$ENTRY5\n""$ENTRY6\n""$ENTRY7" | rofi -dmenu -p Menu ) 

case $ROFI in
	$ENTRY1)
		rofi -show drun -show-icons
		;;
	$ENTRY2)
		~/bluetooth.sh
		;;
	$ENTRY3)
		~/power.sh
		;;
	$ENTRY4)
		~/wallpaper.sh
		;;
	$ENTRY5)
		~/clipboard.sh
		;;
	$ENTRY6)
		~/capture.sh
		;;
	$ENTRY7)
		~/nightlight.sh
		;;
esac
