#!/usr/bin/env bash

WIPE="Wipe clipboard"
CLIPBOARDLIST="See clipboard list"
REMOVE="Remove clipboard item"

if [ "$1" ==  "--list"  ]; then
	cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy --type text/plain
	exit
fi

ROFI=$(echo -e "$CLIPBOARDLIST\n$WIPE\n$REMOVE" | rofi -dmenu -p Clipboard)

case $ROFI in
	$CLIPBOARDLIST) 
		cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy --type text/plain
		;;
	$WIPE)
		cliphist wipe
		;;
	$REMOVE)
		ITEM=$(cliphist list | rofi -dmenu -display-columns 2)
		echo "$ITEM" | cliphist delete 
		if [ "$ITEM" == ""  ]; then exit; else notify-send Clipboard "$ITEM has been removed from clipboard"; fi
		;;
esac
