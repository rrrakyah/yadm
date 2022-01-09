#!/usr/bin/env sh

export XDG_CURRENT_DESKTOP=Unity

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q waybar

# Wait until the processes have been shut down
while pgrep -u $UID -x waybar >/dev/null; do sleep 1; done

# Launch Polybar
waybar -c ~/.config/waybar/configTop.ini &
#waybar -c ~/.config/waybar/configBottom.ini &
