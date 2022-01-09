#!/bin/bash

GOVS=$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors 2>/dev/null\
  | head -1 | sed -e 's/ \([a-zA-Z0-9]\)/\ \n\1/g' -e 's/ $//')

CUR_GOV=$(sudo /home/rak/.config/waybar/scripts/gov.sh listen)
#CPU_SPEED=$(lscpu | grep -i "CPU MHz" | awk '{printf("%.2f GHz\n", $3/1000)}')
CPU_SPEED=$(cat /proc/cpuinfo | grep -i "CPU MHz" | head -n 1 | awk '{printf("%.2f GHz\n", $4/1000)}')

MENU=$(rofi -dmenu -i -theme govs -mesg " $CPU_SPEED       $CUR_GOV" <<< $GOVS)

	case "$MENU" in
		*) sudo /home/rak/.config/waybar/scripts/gov.sh $MENU
	esac
