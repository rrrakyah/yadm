#!/bin/sh

light="'Materia-light-compact'"
dark="'Materia-dark-compact'"

scheme='org.gnome.desktop.interface'

switch() {
	current=$(gsettings get $scheme gtk-theme)
	if [ $current = $light ]; then
		gsettings set $scheme gtk-theme $dark
		echo $(gsettings get $scheme gtk-theme)
	elif [ $current = $dark ]; then
		gsettings set $scheme gtk-theme $light
		echo $(gsettings get $scheme gtk-theme)
	fi
}
switch
