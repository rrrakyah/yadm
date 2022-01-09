#!/bin/bash
ava_gov=$(echo "Avaiable governors:\n\n" 2>/dev/null)
available_governors=$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors 2>/dev/null\
  | head -1 | sed -e 's/ \([a-zA-Z0-9]\)/\\n\1/g' -e 's/ $//')

available_governors_alt=$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors 2>/dev/null\
  | head -1 | sed -e 's/ \([a-zA-Z0-9]\)/\|\1/g' -e 's/ $//')
#if [ $# -ne 1 ]
#then
#  echo "Usage: $0 [$available_governors]"
#fi

function current_cpu_governor ()
{
  #echo -n "CPU scaling governor is currently set to: "
  cpu_scaling_governor="NOT SET"
  for governor in $(ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
  do
	cpu_scaling_governor=$(cat $governor 2>/dev/null)
  	if [ "${cpu_scaling_governor}" = "powersave" ]; then
		cpu_scaling_governor="Powersaving"
	elif [ "${cpu_scaling_governor}" = "schedutil" ]; then
		cpu_scaling_governor="Balanced"
	elif [ "${cpu_scaling_governor}" = "performance" ]; then
			cpu_scaling_governor="Performance"
  	else
		cpu_scaling_governor=$(cat $governor 2>/dev/null)
  	fi
  done
  #echo "$cpu_scaling_governor"
  FORMAT='{"text": "'$cpu_scaling_governor'", "tooltip": "'$ava_gov$available_governors'", "class": "'$cpu_scaling_governor'", "alt": "'$cpu_scaling_governor'"}'
  echo $FORMAT
}

function current_cpu_governor_short ()
{
  cpu_scaling_governor="NOT SET"
  for governor in $(ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
  do
	cpu_scaling_governor=$(cat $governor 2>/dev/null)
  done

  echo $cpu_scaling_governor
  
}

function toggle() {
	for governor in $(ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
	do
		cpu_scaling_governor=$(cat $governor 2>/dev/null )
  		if [ "${cpu_scaling_governor}" = "powersave" ]; then
			new_governor="schedutil"
		elif [ "${cpu_scaling_governor}" = "schedutil" ]; then
			new_governor="powersave"
		elif [ "${cpu_scaling_governor}" = "performance" ]; then
			new_governor="performance"
  		fi
	done
}

new_governor=""
if [ $# -eq 0 ]; then
	current_cpu_governor;
	exit 0
elif [ "$1" = "toggle" ]; then
	toggle;
elif [ "$1" = "listen" ]; then
	current_cpu_governor_short;
	exit 1
else
 	new_governor="$1"
fi

user_id=`whoami`
if [[ "$user_id" != "root" ]]; then
	echo "$0: please run this script as root user."
#	exit
fi

#if [ -z $(echo $available_governors | sed -e 's/^/|/' -e 's/$/|/' | grep "|$new_governor|") ]; then
if [[ $available_governors != *$new_governor* ]]; then
	echo "Mode '$new_governor' is not supported"
	exit 1
#else
	#echo "Setting CPU into '$new_governor' mode..."
fi

for governor in $(ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
do
	echo "$new_governor" > $governor
done

exit 0
