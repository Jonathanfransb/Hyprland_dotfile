#!/usr/bin/env bash
SCREEN="󰍹  Screen"
COLORPICKER="󰴱 Color"
SNIPPET=" Snippet"
if [ $1 == "--print" ]; then
	ROFI="$SCREEN"
else
	ROFI=$(echo -e "$SCREEN\n$SNIPPET\n$COLORPICKER" | rofi -dmenu -p Capture)
fi
case $ROFI in
	$SCREEN)
		grim
		notify-send -t 5000 "Screen has been captured"
		;;
	$COLORPICKER)
		sleep 0.2
		hyprpicker --autocopy
		;;
	$SNIPPET)
		grim -g "$(slurp)"
		;;
esac
