#! /bin/bash

swayidle -w \
            timeout 300 'swaylock -f' \
            timeout 900 'systemctl suspend' \
            before-sleep 'swaylock -f'
