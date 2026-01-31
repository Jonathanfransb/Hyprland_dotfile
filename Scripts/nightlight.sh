#!/usr/bin/env bash

TURNON="Enable nightlight"
TURNOFF="Disable nightlight"

ROFI=$(echo -e "$TURNON\n$TURNOFF" | rofi -dmenu)

case $ROFI in
	$TURNON)
		hyprctl hyprsunset temperature 4500
		;;
	$TURNOFF)
		hyprctl hyprsunset identity
esac
