#! /bin/bash

DARK="'Mojave-dark-alt'"
LIGHT="'Mojave-light-alt'"

DARK_ICON="'Papirus-Dark'"
LIGHT_ICON="'Papirus'"

function themeToggle(){
	SETTING=$(gsettings get org.gnome.desktop.interface gtk-theme)
	ICON=$(gsettings get org.gnome.desktop.interface icon-theme)
	if [ "$SETTING" = "$DARK" ]; then
		NEW_THEME=$LIGHT
		NEW_ICON=$LIGHT_ICON
	elif [ "$SETTING" = "$LIGHT" ]; then
		NEW_THEME=$DARK
		NEW_ICON=$DARK_ICON
	fi

	gsettings set org.gnome.desktop.interface gtk-theme $NEW_THEME
	gsettings set org.gnome.desktop.interface icon-theme $NEW_ICON
}

themeToggle
