#! /bin/sh

#entries=" Lock\n Suspend\n Logout\n Reboot\n Shutdown\n Hibernate"

#entries="Lock Suspend Logout Reboot Shutdown Hibernate"

#selected=$(echo $entries | rofi -show-icons -m 0 -dmenu -sep ',' -p "power" -i | awk '{print tolower($1)}')
selected=$(printf '%s\n' " Lock" " Suspend" " Logout" " Reboot" " Shutdown" " Hibernate" | wofi -i --width 150 --height 242 --dmenu --location 3 --xoffset=-30 --prompt "Powermenu" --cache-file /dev/null)

case $selected in
  *Lock) swaylock --config /home/rak/.config/swaylock/config;;
  *Suspend) systemctl suspend;;
  *Logout) swaymsg exit;;
  *Reboot) systemctl reboot;;
  *Shutdown) poweroff;;
  *Hibernate) systemctl hibernate
esac
