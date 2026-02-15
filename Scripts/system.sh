CLIP="  Clipboard"
CAPTURE="  Capture"
POWER="󰐥  Power"
NIGHTLIGHT="  Nightlight"

ROFI=$(echo -e "$CLIP\n""$CAPTURE\n""$POWER\n""$NIGHTLIGHT" | rofi -dmenu)

case $ROFI in
	$CLIP)
		~/clipboard.sh
		;;
	$CAPTURE)
		~/capture.sh
		;;
	$POWER)
		~/power.sh
		;;
	$NIGHTLIGHT)
		~/nightlight.sh
		;;
esac
