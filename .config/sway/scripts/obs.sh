#!/bin/sh
sudo modprobe v4l2loopback video_nr=5 card_label="Virtual Camera" exclusive_caps=1
