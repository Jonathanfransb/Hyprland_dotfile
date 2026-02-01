#!/usr/bin/env bash

IMGPATH="/usr/share/backgrounds/;/home/jonathan/Imagens/"
WALLPAPERAPP="swaybg"
WALLPAPERCOMMAND="swaybg -i"

declare -i PATHCOUNT="$(echo $IMGPATH | awk -F ';' '{ print NF }')"
DIRS=$(	for NUM in $(seq 1 $PATHCOUNT); do
	echo "$IMGPATH" | awk -v NUMBERAWK="$NUM" -F ";" '{ print $NUMBERAWK }'
done)

FIRSTDIR=1


options_menu() {
			BACKGROUND="Set as background"
			BACKGROUNDPERSISTENT="Set persistent background"
			PREVIEW="Preview"
			GOBACK="Back"
			ROFISUBMENU=$(echo -e "$BACKGROUND\n$BACKGROUNDPERSISTENT\n$PREVIEW\n$GOBACK" | rofi -dmenu)
			case $ROFISUBMENU in
				$BACKGROUND)
					if [ $(pidof $WALLPAPERAPP > /dev/null 2>&1; echo $?) -eq 0 ]; then
						killall $WALLPAPERAPP
						$WALLPAPERCOMMAND "$1$2"
						exit
					else
						$WALLPAPERCOMMAND "$1$2"
						exit
					fi
					;;
				$BACKGROUNDPERSISTENT)
					WALLPAPERSTARTUPCONTENT=$(cat ~/wallpaperstartup)

					if [ $(pidof $WALLPAPERAPP > /dev/null 2>&1; echo $?) -eq 0 ]; then
						killall $WALLPAPERAPP
					fi

					if [[ $WALLPAPERSTARTUPCONTENT == *"$WALLPAPERAPP"* ]]; then
						echo "$WALLPAPERCOMMAND $1$2" > ~/wallpaperstartup
						$WALLPAPERCOMMAND $1$2
						exit

					else
						echo "$WALLPAPERCOMMAND $1$2" > ~/wallpaperstartup
						$WALLPAPERCOMMAND $1$2
						exit
					fi
					;;
				$PREVIEW)
					feh --scale-down -g 640x360 "$1$2"
					options_menu "$CURRENTDIR" "$IMGS"
					;;
				$GOBACK) 
					sub_menu_logic
					;;

				*)
					echo "No option selected"
					exit
					;;

			esac

}

main_menu() {
		while true; do
			if [ "$CHECKIMGS" == "" -a "$CHECKSUBDIRECTORIES" == "" -a $FIRSTDIR == 0 ]; then
				echo "Um erro ocorreu 1"
				exit
			fi
			
			if [ $FIRSTDIR -eq 1 ]; then
				ROFI="$(echo "$DIRS" | rofi -dmenu)"
				CHECKIMGS=$(ls "$ROFI" | awk '/jpeg|jpg|png/ {print}')
				CHECKSUBDIRECTORIES="$(ls -d "$ROFI"*/)"
		      	 	CURRENTSUBDIRECTORIES_NAMES=$(echo "$CHECKSUBDIRECTORIES" | awk -F "/" 'NFN=NF-1 {print $NFN}'| sed -e "s/$/\//")
				CURRENTDIR="$(echo "$ROFI")"
			fi

			if [ "$CHECKSUBDIRECTORIES" == "" -a $FIRSTDIR -eq 0 ]; then
				ROFI="$(echo -e "$CHECKIMGS" | rofi -dmenu -p $CURRENTDIR)"
			elif [ "$CHECKIMGS" == ""  -a $FIRSTDIR -eq 0 ]; then
				ROFI="$(echo -e "$CURRENTSUBDIRECTORIES_NAMES" | rofi -dmenu)"
			elif [[ "$CHECKIMGS" != "" && "$CHECKSUBDIRECTORIES" != "" && $FIRSTDIR == 0 ]]; then
				ROFI="$(echo -e "$CURRENTSUBDIRECTORIES_NAMES\n$CHECKIMGS" | rofi -dmenu)"
			fi

			if [ ! "$ROFI" ]; then
				echo "Um erro ocorreu 2"
				exit
			fi

			if [[ "$ROFI" == *jpg* || "$ROFI" == *png* || "$ROFI" == *jpeg* ]]; then
				IMGS="$(echo $ROFI)"
				options_menu "$CURRENTDIR" "$IMGS"
			fi

			if [[ "$ROFI" != *jpg* && "$ROFI" != *png* && "$ROFI" != *jpeg* && "$ROFI" != "" && $FIRSTDIR == 0 ]]; then
				CHECKIMGS=$(ls "$CURRENTDIR""$ROFI" | awk '/jpeg|jpg|png/ {print}')
				CHECKSUBDIRECTORIES="$(ls -d "$CURRENTDIR""$ROFI"*/)"
				CURRENTDIR="$(echo "$CURRENTDIR""$ROFI")"
			  	CURRENTSUBDIRECTORIES_NAMES=$(echo "$CHECKSUBDIRECTORIES" | awk -F "/" 'NFN=NF-1 {print $NFN}'| sed -e "s/$/\//")
			fi
			FIRSTDIR=0
done
}

main_menu
