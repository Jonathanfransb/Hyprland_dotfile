#!/usr/bin/env bash

IMGPATH="/usr/share/backgrounds/;/home/jonathan/Wallpapers/"
WALLPAPERAPP="awww"
WALLPAPERCOMMAND="awww img"
EXTENSIONS="jpg|jpeg|png|gif"

DIRS=$(	echo "$IMGPATH" | sed -e 's/;/\n/')

FIRSTDIR=1


killprocess() {
	CHECKPROCESS=$(pgrep "$WALLPAPERAPP"$ > /dev/null 2>&1 ; echo $?)
	if [ $CHECKPROCESS -ne 0  ]; then
		echo "$WALLPAPERAPP not found"
	elif [ $CHECKPROCESS -eq 0 ]; then
		kill $(pgrep "$WALLPAPERAPP"$)
	fi


}

options_menu() {
			BACKGROUND="Set as background"
			BACKGROUNDPERSISTENT="Set persistent background"
			PREVIEW="Preview"
			GOBACK="Back"
			ROFISUBMENU=$(echo -e "$BACKGROUND\n$PREVIEW\n$GOBACK" | rofi -dmenu)
			case $ROFISUBMENU in
				$BACKGROUND)
					if [[ "$2" =~ $EXTENSIONS ]]; then
						killprocess
						$WALLPAPERCOMMAND $1$2
						exit
					fi
					;;
				$BACKGROUNDPERSISTENT)
					WALLPAPERSTARTUPCONTENT=$(cat ~/wallpaperstartup)

					if [ ! -e ~/wallpaperstartup ]; then
						echo "" > ~/wallpaperstartup
						chmod +x ~/wallpaperstartup
					fi
					if [[  "$2" =~ $EXTENSIONS   ]]; then
						killprocess
						echo "$WALLPAPERCOMMAND $1$2" > ~/wallpaperstartup
						$WALLPAPERCOMMAND $1$2
						exit
					fi

					;;
				$PREVIEW)
					if [[ "$2" =~ jpg|jpeg|png  ]]; then
						feh --scale-down -g 640x360 $1$2
						options_menu "$CURRENTDIR" "$WALLPAPER"

					elif [[ "$2" =~ gif ]]; then
						exit
					fi
					;;
				$GOBACK) 
					main_menu
					;;

				*)
					echo "No option selected"
					exit
					;;

			esac

}

main_menu() {
		while true; do
			if [ "$CHECKWALLPAPERS" == "" -a "$CHECKSUBDIRECTORIES" == "" -a $FIRSTDIR == 0 ]; then
				echo "Um erro ocorreu 1"
				exit
			fi
			
			if [ $FIRSTDIR -eq 1 ]; then
				ROFI="$(echo "$DIRS" | rofi -dmenu)"
				CHECKWALLPAPERS=$(ls "$ROFI" | awk -v EXTENSIONS="$EXTENSIONS" '$0 ~ EXTENSIONS {print}')
				CHECKSUBDIRECTORIES="$(ls -d "$ROFI"*/)"
		      	 	CURRENTSUBDIRECTORIES_NAMES=$(echo "$CHECKSUBDIRECTORIES" | awk -F "/" 'NFN=NF-1 {print $NFN}'| sed -e "s/$/\//")
				CURRENTDIR="$(echo "$ROFI")"
			fi

			if [ "$CHECKSUBDIRECTORIES" == "" -a $FIRSTDIR -eq 0 ]; then
				ROFI="$(echo -e "$CHECKWALLPAPERS" | rofi -dmenu -p $CURRENTDIR)"
			elif [ "$CHECKWALLPAPERS" == ""  -a $FIRSTDIR -eq 0 ]; then
				ROFI="$(echo -e "$CURRENTSUBDIRECTORIES_NAMES" | rofi -dmenu)"
			elif [[ "$CHECKWALLPAPERS" != "" && "$CHECKSUBDIRECTORIES" != "" && $FIRSTDIR == 0 ]]; then
				ROFI="$(echo -e "$CURRENTSUBDIRECTORIES_NAMES\n$CHECKWALLPAPERS" | rofi -dmenu)"
			fi

			if [ ! "$ROFI" ]; then
				echo "Um erro ocorreu 2"
				exit
			fi

			if [[ "$ROFI" =~ $EXTENSIONS ]]; then
				echo "$ROFI"
				WALLPAPER="$(echo "$ROFI")"
				options_menu "$CURRENTDIR" "$WALLPAPER"
			fi


			if [[ ! "$ROFI" =~ $EXTENSIONS  && $FIRSTDIR == 0 ]]; then
				echo "Rofi:$ROFI"
				CHECKWALLPAPERS=$(ls "$CURRENTDIR""$ROFI" | awk -v EXTENSIONS="$EXTENSIONS" '$0 ~ EXTENSIONS {print}')
				CHECKSUBDIRECTORIES="$(ls -d "$CURRENTDIR""$ROFI"*/)"
				CURRENTDIR="$(echo "$CURRENTDIR""$ROFI")"
			  	CURRENTSUBDIRECTORIES_NAMES=$(echo "$CHECKSUBDIRECTORIES" | awk -F "/" 'NFN=NF-1 {print $NFN}'| sed -e "s/$/\//")
			fi
			FIRSTDIR=0
done




}

main_menu
