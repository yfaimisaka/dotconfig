#!/usr/bin/env bash

# Add this script to your wm startup file.

## Multi monitor plan
#if type "xrandr"; then
#	  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#		      MONITOR=$m polybar --reload top &
#		        done
#		else
#			  polybar --reload top &
#fi
# Then you can use:
# [bar/top]
# monitor = ${env:MONITOR:}
# in config.ini to show top on multi monitor

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
#polybar -q top -c "$DIR"/config.ini &
#
#polybar -q bottom -c "$DIR"/config.ini &

if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload top &
        MONITOR=$m polybar --reload bottom &
    done
else
    polybar --reload top &
    polybar --reload bottom &
fi
