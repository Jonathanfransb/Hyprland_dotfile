#!/usr/bin/env bash

CURSORTHEMES="  Cursor"
WALLPAPERS="  Wallpapers"

ROFI=$(echo -e "$CURSORTHEMES\n""$WALLPAPERS" | rofi -dmenu)

case $ROFI in
	$CURSORTHEMES)
		~/cursortheme.sh
		;;
	$WALLPAPERS)
		~/wallpaper.sh
		;;
esac
