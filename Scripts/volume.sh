#!/usr/bin/env bash

VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F "/" '{print $2}' | tr -d [:space:])
MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk -F ":" '{print $2}')

if [ $MUTE = 'no' ]; then
    echo "Vol:$VOLUME"
elif [ $MUTE = 'yes' ]; then
	echo muted
fi


