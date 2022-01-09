#! /bin/bash

while true; do
	files=($HOME/Pictures/Background/*)
	SEL=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}") 
	swaybg -i $SEL -m fill
	sleep 2h
	echo test
done
