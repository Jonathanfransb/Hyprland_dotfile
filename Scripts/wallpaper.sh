#!/usr/bin/env bash

IMGPATH="/usr/share/backgrounds/;/home/jonathan/Imagens/"
WALLPAPERAPP="swaybg"
WALLPAPERCOMMAND="swaybg -i"

declare -i PATHCOUNT="$(echo $IMGPATH | awk -F ';' '{ print NF }')"

show_menu() {
	DIRS=$(	for NUM in $(seq 1 $PATHCOUNT); do
		echo "$IMGPATH" | awk -v NUMBERAWK="$NUM" -F ";" '{ print $NUMBERAWK }'
	done)

	ROFI="$(echo -e "$DIRS" | rofi -dmenu -p Wallpaper:)"
		case $ROFI in
			$ROFI)
				if [ "$ROFI" == "" ]; then
					exit
				else
					IMGS=$(ls $ROFI | awk '/jpg|jpeg|png/ {print}')
					SUBDIRECTORIES=$(ls -d "$ROFI"*/ | awk '{print}')
				fi
				echo "IMGS: $IMGS" "Subdirectories: $SUBDIRECTORIES"
				if [ "$IMGS" == "" -a "$SUBDIRECTORIES" == "" ]; then
					exit
				else
					sub_menu
				fi
				;;
			*)
				echo "No option selected"
				;;

		esac
	
}

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
					if [[ "$IMGS" != "" ]]; then 
						sub_menu_logic
					else
						sub_menu
					fi
					;;

				*)
					echo "No option selected"
					exit
					;;

			esac

}

sub_menu_logic() {
			while true; do
				if [ "$CHECKIMGS" == "" -a "$CHECKSUBDIRECTORIES" == "" ]; then
					echo "Um erro ocorreu"
					exit
				fi

				if [ "$CHECKSUBDIRECTORIES" == "" ]; then
					ROFI3="$(echo -e "$CHECKIMGS" | rofi -dmenu -p $CURRENTDIR)"
				elif [ "$CHECKIMGS" == "" ]; then
					ROFI3="$(echo -e "$CURRENTSUBDIRECTORIES_NAMES" | rofi -dmenu)"
				elif [[ "$CHECKIMGS" != "" && "$CHECKSUBDIRECTORIES" != "" ]]; then
					ROFI3="$(echo -e "$CURRENTSUBDIRECTORIES_NAMES\n$CHECKIMGS" | rofi -dmenu)"
				fi

				if [ ! "$ROFI3" ]; then
					echo "Um erro ocorreu"
					exit
				fi

				if [[ "$ROFI3" == *jpg* || "$ROFI3" == *png* || "$ROFI3" == *jpeg* ]]; then
					IMGS="$(echo $ROFI3)"
					options_menu "$CURRENTDIR" "$IMGS"
				fi

				if [[ "$ROFI3" != *jpg* || "$ROFI3" != *png* || "$ROFI3" != *jpeg* && "$ROFI3" != "" ]]; then

					CHECKIMGS=$(ls "$CURRENTDIR""$ROFI3" | awk '/jpeg|jpg|png/ {print}')
					CHECKSUBDIRECTORIES="$(ls -d "$CURRENTDIR""$ROFI3"*/)"
					CURRENTDIR="$(echo "$CURRENTDIR""$ROFI3")"
					declare -i NUMBEROFFIELDSSUBDIRECTORIES=$(( $(echo "$CHECKSUBDIRECTORIES" | awk -F "/" '{print NF}' | uniq) - 1 ))
		      		  	CURRENTSUBDIRECTORIES_NAMES=$(echo "$CHECKSUBDIRECTORIES" | cut -d '/' -f $NUMBEROFFIELDSSUBDIRECTORIES | sed -e "s/$/\//")
				fi
done




}

sub_menu() {

	declare -i NUMBEROFFIELDSSUBDIRECTORIES=$(( $(echo "$SUBDIRECTORIES" | awk -F "/" '{print NF}' | uniq) - 1 ))
		CURRENTSUBDIRECTORIES_NAMES=$(echo "$SUBDIRECTORIES" | cut -d '/' -f $NUMBEROFFIELDSSUBDIRECTORIES | sed -e "s/$/\//")

	BACK_STATUS=0
	if [ "$SUBDIRECTORIES" == "" ]; then
		ROFI2=$(echo "$IMGS" | rofi -dmenu )
	elif [ "$IMGS" == "" ]; then
		ROFI2=$(echo "$CURRENTSUBDIRECTORIES_NAMES" | rofi -dmenu )
	else
		ROFI2=$(echo -e "$CURRENTSUBDIRECTORIES_NAMES\n$IMGS" | rofi -dmenu )
	fi
	if [ -z $ROFI2  ]; then
		exit
	fi
		if [[ "$ROFI2" == *jpg* || "$ROFI2" == *jpeg* || "$ROFI2" == *png* ]]; then
			if [[ "$IMGS" == "" ]]; then
				exit
			else
				IMGS="$(echo $ROFI2)"
				options_menu "$ROFI" "$IMGS"
			fi
		else
		
			if [ $BACK_STATUS -eq 0 ]; then
			echo "OIII!"
			CURRENTDIR="$(echo "$ROFI""$ROFI2")"
			CHECKSUBDIRECTORIES="$(ls -d $CURRENTDIR*/ | awk '{print}')"
			CHECKIMGS="$(ls $CURRENTDIR | awk  '/jpeg|jpg|png/ {print}')"
			declare -i NUMBEROFFIELDSCURRENTDIR=$(( $(echo "$CURRENTDIR" | awk -F "/" '{print NF}') - 1 ))
			declare -i NUMBEROFFIELDSSUBDIRECTORIES=$(( $(echo "$CHECKSUBDIRECTORIES" | awk -F "/" '{print NF}' | uniq) - 1 ))
			CURRENTDIR_NAME="$(echo $CURRENTDIR | cut -d '/' -f $NUMBEROFFIELDSCURRENTDIR)"
			CURRENTSUBDIRECTORIES_NAMES=$(echo "$CHECKSUBDIRECTORIES" | cut -d '/' -f $NUMBEROFFIELDSSUBDIRECTORIES | sed -e "s/$/\//")
			BACK_STATUS=1
			sub_menu_logic
			fi
		fi
		

}

show_menu

