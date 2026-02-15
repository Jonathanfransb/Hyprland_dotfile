#!/usr/bin/bash

ENTRY1="󰵆  Apps"
ENTRY2="  Bluetooth"
ENTRY3="  System"
ENTRY4="  Themes"
ENTRY5="󰞅  Emoji"

ROFI=$(echo -e "$ENTRY1\n""$ENTRY2\n""$ENTRY3\n""$ENTRY4\n""$ENTRY5" | rofi -dmenu -p Menu ) 

case $ROFI in
	$ENTRY1)
		rofi -show drun -show-icons -theme-str "window {width: 50%;} 
			inputbar { margin: 3% 0% 0% 15%; padding: 0px;} 
			listview {columns: 3; dynamic: true; lines: 3;} 
			element {orientation: vertical; padding: 20px 0px;}
			element-icon {size: 28;}
			element.selected { background-color: #2a2a27 ; } 
			element-text.selected {background-color: #2a2a27;} 
			element-icon.selected { background-color: #2a2a27;}" 
		;;
	$ENTRY2)
		~/bluetooth.sh
		;;
	$ENTRY3)
		~/system.sh
		;;
	$ENTRY4)
		~/themes.sh
		;;
	$ENTRY5)
		rofi -show emoji
		;;
esac
