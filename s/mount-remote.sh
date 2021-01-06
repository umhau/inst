#!/bin/bash

# make sure that passwordless login works before using

# This could turn into something much more complex later on - set up a VPN back
# to the home network, then automount files. 

# include network storage mounts.

declare -a devmounts
# declare -a networkmounts

devmounts=(
    libraries/in-mem-computing
    libraries/inst
    libraries/umhau.github.io
    libraries/PXEN
    libraries/VLF_radio_communication
    libraries/cheap-vps-hosting
)



echo 'as'

case $1 in

    mount)
    echo "mounting drives"
    for mount in "${devmounts[@]}"
    do 
        mkdir -pv ~/"$mount"
        sshfs -o ServerAliveInterval=15 -o reconnect mal@dev:"$mount" ~/"$mount"  
    done
    ;;

    umount)
    echo "unmounting drives"

    for mount in "${devmounts[@]}"
    do 
        sudo fusermount3 -u ~/"$mount"
    done
    ;;

    *)
    echo "unknown option"
    ;;

esac

echo ''
    
