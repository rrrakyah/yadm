#! /bin/bash
if [[ -z $(swaymsg -t get_tree | grep '"app_id": "dropterm"') ]]; then
	footclient -o colors.alpha=0.45 -a dropterm &
	sleep .1
fi
swaymsg "[app_id=\"dropterm\"] scratchpad show, sticky toggle, resize set 100 ppt 30 ppt, move position 0 0"
