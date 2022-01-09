#!/bin/bash

declare -A SINK_NICKNAMES
#SINK_NICKNAMES["alsa_output.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo"]="Headphones"
SINK_NICKNAMES["alsa_output.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo"]="Headphones"
SINK_NICKNAMES["bluez_output.CB_98_76_00_7C_3F.a2dp-sink"]="Bluetooth"
SINK_NICKNAMES["alsa_output.pci-0000_00_1f.3.analog-stereo"]="Built-in"

SINK_BLACKLIST=(
    "alsa_output.usb-SinkYouDontUse-00.analog-stereo"
)

MAX_VOL=130
VOLUME_ICONS=( "" "" "" )  # Volume icons array, from lower volume to higher
MUTED_ICON=""  # Muted volume icon



function getNickname() {
    if [ -n "${SINK_NICKNAMES[$CUR_SINK]}" ]; then
        nickname="${SINK_NICKNAMES[$CUR_SINK]}"
    else
        nickname="$CUR_SINK"
    fi
}

function getCurVol() {
    curVol=$(pactl list sinks | grep -A 15 -i "$1" | grep -i "volume" | awk -F : '{print $3; exit}' | grep -o -P '.{0,3}%' | sed 's/.$//' | tr -d ' ' )
}

function getIsMuted() {
    isMuted=$(pactl list sinks | grep -A 15 -i "$1" | awk '/Mute/ {print $2; exit}')
}

function print() {
	GET_SINKS=$(pactl list sinks short | awk -v sink="$1" '{print $2}')
	CUR_SINK=$(pactl info | sed -En 's/Default Sink: (.*)/\1/p')
	
	curSinkName=$CUR_SINK
	
	curSink=$(pactl list sinks | grep -B 2 -i $curSinkName | head -1 | awk '{print $2}' | tr -d '#')
	

    getCurVol "$CUR_SINK"
    getIsMuted "$CUR_SINK"

    # Fixed volume icons over max volume
    local iconsLen=${#VOLUME_ICONS[@]}
    if [ "$iconsLen" -ne 0 ]; then
        local volSplit=$((MAX_VOL / iconsLen))
        for i in $(seq 1 "$iconsLen"); do
            if [ $((i * volSplit)) -ge "$curVol" ]; then
                volIcon="${VOLUME_ICONS[$((i-1))]}"
                break
            fi
        done
    else
        volIcon=""
    fi

    getNickname "$curSink"
	
    # Showing the formatted message
    if [ "$isMuted" = "yes" ]; then
    	CUR_ICON=$MUTED_ICON
    	#echo '{"text": "'${curVol}% ${SINK_ICON}${nickname}'", "tooltip": "'${curVol}% ${SINK_ICON}${nickname}'", "class": "'$isMuted'", "alt": "'$CUR_ICON'"}'
    else
    	CUR_ICON=$volIcon
    	#echo '{"text": "'${curVol}% ${SINK_ICON}${nickname}'", "tooltip": "'${curVol}% ${SINK_ICON}${nickname}'", "class": "'$isMuted'", "alt": "'$CUR_ICON'"}'
    fi

	echo '{"text": "'${curVol}% ${SINK_ICON}${nickname}'", "tooltip": "'${curVol}% ${SINK_ICON}${nickname}'", "class": "'$isMuted'", "alt": "'$CUR_ICON'"}' 2>/dev/null
}

function output() {
	print
	pactl subscribe | grep --line-buffered change | while read -r; do
		print
	done
}

function nextSink() {
    # The final sinks list, removing the blacklisted ones from the list of
    # currently available sinks.

	CUR_SINK=$(pactl info | sed -En 's/Default Sink: (.*)/\1/p')
	curSinkName=$CUR_SINK
	curSink=$(pactl list sinks | grep -B 2 -i $curSinkName | head -1 | awk '{print $2}' | tr -d '#')

    # Obtaining a tuple of sink indexes after removing the blacklisted devices
    # with their name.
    sinks=()
    local i=0
    while read -r line; do
        index=$(echo "$line" | cut -f1)
        name=$(echo "$line" | cut -f2)

        # If it's in the blacklist, continue the main loop. Otherwise, add
        # it to the list.
        for sink in "${SINK_BLACKLIST[@]}"; do
            if [ "$sink" = "$name" ]; then
                continue 2
            fi
        done

        sinks[$i]="$index"
        i=$((i + 1))
    done < <(pactl list short sinks)
    # If the resulting list is empty, nothing is done
    if [ ${#sinks[@]} -eq 0 ]; then return; fi

    # If the current sink is greater or equal than last one, pick the first
    # sink in the list. Otherwise just pick the next sink avaliable.
    local newSink
    if [ "$curSink" -ge "${sinks[-1]}" ]; then
        newSink=${sinks[0]}
    else
        for sink in "${sinks[@]}"; do
            if [ "$curSink" -lt "$sink" ]; then
                newSink=$sink
                echo $newSink
                break
            fi
        done
    fi

    # The new sink is set
    pactl set-default-sink "$newSink"

    # Move all audio threads to new sink
    local inputs=$(pactl list short sink-inputs | cut -f 1)
    for i in $inputs; do
        pactl move-sink-input "$i" "$newSink"
    done
}

case "$1" in
	next)
		nextSink
		;;
	*)
		output
		;;
esac

