#!/bin/sh

switch() {
	current=$(cat /sys/devices/system/cpu/intel_pstate/no_turbo)
	if [ $current = "1" ]; then
		echo "0" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
		notify-send "Intel Turbo Boost" "Turbo Boost enabled"
	elif [ $current = "0" ]; then
		echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
		notify-send "Intel Turbo Boost" "Turbo Boost disabled"
	fi
}
switch
