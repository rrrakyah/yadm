#!/bin/bash

nprofile=$(cat /var/lib/power-profiles-daemon/state.ini | tail -n 1 | cut -c 9-)

selected=$(printf '%s\n' " performance" " balanced" " power-saver" | wofi -i --width 150 --height 133 --dmenu --location 3 --xoffset=-30 --prompt $nprofile --cache-file /dev/null)

case $selected in
  *performance) powerprofilesctl set performance;;
  *balanced) powerprofilesctl set balanced;;
  *power*) powerprofilesctl set power-saver;;
esac
