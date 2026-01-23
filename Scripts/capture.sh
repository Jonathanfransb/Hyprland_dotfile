#!/usr/bin/env bash

COLORPICKER="󰴱 Color"
SCREENSHOT="󰍹  Screen"

ROFI=$(echo -e "$SCREENSHOT\n$COLORPICKER" | rofi -dmenu -p Capture)

case $ROFI in
	$SCREENSHOT)
		slurp | grim
		;;
	$COLORPICKER)
		hyprpicker --autocopy
		;;
esac
