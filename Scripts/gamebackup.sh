#!/usr/bin/env bash
gamelist=("Hollow_Knight" "Terraria" "Minecraft" "HuniePop")
gamepaths=("Hollow_Knight;/home/jonathan/.config/unity3d/Team\ Cherry/Hollow\ Knight\n" "Minecraft;/home/jonathan/.local/share/atlauncher/instances/FabulouslyOptimized\n" "Terraria;/home/jonathan/.local/share/Terraria\n" "Huniepop;/home/jonathan/.config/unity3d/HuniePot/HuniePop\n")
gamecount=$(echo ${gamelist[@]} | awk -F ' ' '{print NF}')

echo "Choose a option:"
echo "[1] Download a backup"
echo "[2] Backup a game"
echo "[3] Exit"
read -s -n 1 Option
case $Option in 
	1)
		echo "Choose the game to download the backup:"
		for i in $(seq 0 $gamecount ); do
			if [ $i -eq $gamecount ]; then
				echo "[$(( $i + 1 ))] Exit"
				break
			fi
			echo "[$(( 1 + $i  ))] $(echo ${gamelist[$i]} | sed -e 's/_/ /g')"
		done
		read -s -n 1 Option

		if [ $Option -eq $(( $gamecount  + 1 )) ]; then
			echo "Exiting the program."
			exit
		fi
		game=$(echo ${gamelist[$(( $Option -1 ))]})
		gamepath=$(echo -e "${gamepaths[@]}" | sed -e 's/^\ //g' | awk -v game="$game" -F ";" ' $0 ~ game {print $2}')
		mkdir -p "$gamepath"
		read -p "Insert the sftp server ip: " ip
		read -p "Insert the sftp server port: " port
		echo "get -r $(echo "$game"/* | sed -e 's/_/\ /g') $gamepath"/ | sftp -P $port $ip
		exit
		;;
	2)
		echo "Choose the game to backup"
		for i in $(seq 0 $gamecount ); do
			if [ $i -eq $gamecount ]; then
				echo "[$(( $i + 1 ))] Exit"
				break
			fi
			echo "[$(( 1 + $i  ))] $(echo ${gamelist[$i]} | sed -e 's/_/ /g')"
		done

		read -s -n 1 Option

		if [ $Option -eq $(( $gamecount  + 1 )) ]; then
			echo "Exiting the program."
			exit
		fi
		game=$(echo ${gamelist[$(( $Option -1 ))]})
		gamepath=$(echo -e "${gamepaths[@]}" | sed -e 's/^\ //g' | awk -v game="$game" -F ";" ' $0 ~ game {print $2}')
		read -p "Insert the sftp server ip: " ip
		read -p "Insert the sftp server port: " port
		echo "put -r "$gamepath"/* $(echo "$game" | sed -e 's/_/\ /g')" | sftp -P $port $ip
		;;
	3)
		echo "Exiting the program."
		exit
		;;
	*)
		echo "Option not found. Exiting the program"
		;;

esac


