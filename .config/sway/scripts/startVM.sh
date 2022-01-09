#!/bin/sh
# call this script with domainname as parameter 
# to start domain and open viewer

/usr/bin/pkexec /usr/bin/virsh start $1         # domain must be known to virsh
/usr/bin/virt-viewer --connect qemu:///system -w -f --attach $1     # -w to wait until domain is running. 
