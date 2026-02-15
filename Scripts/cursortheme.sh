#!/usr/bin/env bash

CURSORS=$(ls -d ~/.icons/*/ | awk -F "/" 'NFN=NF-1 {print $NFN}')

ROFI=$(echo "$CURSORS" | rofi -dmenu)
if [ -z $ROFI ]; then
	echo "ROFI is empty"
	exit
fi
sed -i "s/gtk-cursor-theme-name.*$/gtk-cursor-theme-name=\"$ROFI\"/" ~/.gtkrc-2.0
sed -i "s/gtk-cursor-theme-name.*$/gtk-cursor-theme-name=$ROFI/" ~/.config/gtk-3.0/settings.ini
sed -i "s/XCURSOR_THEME.*$/XCURSOR_THEME, $ROFI/" ~/.config/hypr/hyprland.conf
sed -i "s/HYPRCURSOR_THEME.*$/HYPRCURSOR_THEME, $ROFI/" ~/.config/hypr/hyprland.conf



