#!/bin/bash

# This file is executed whenever the machine is connected or disconnected from
# a network.

# if network names were still simple and predictable, a case statement would be
# ideal. however, with the newly wide variety of possible interface names, a 
# case statement is impractical.

# sources
# https://raspberrypi.stackexchange.com/a/96077
# https://wiki.archlinux.org/index.php/Iwd#Usage

# -a file
# Run in daemon mode executing the action file based on events from 
# wpa_supplicant. The specified file will be executed with the first argument 
# set to interface name and second to "CONNECTED" or "DISCONNECTED" depending on
# the event. This can be used to execute networking tools required to configure
# the interface.

# Additionally, three environmental variables are available to the file:
# WPA_CTRL_DIR, WPA_ID, and WPA_ID_STR. WPA_CTRL_DIR contains the absolute path
# to the ctrl_interface socket. WPA_ID contains the unique network_id identifier
# assigned to the active network, and WPA_ID_STR contains the content of the 
# id_str option.

case "$2" in
CONNECTED)

    # do stuff on connect; wait 10 sec for ipv4 address to settle
    sleep 10

    # if connected to the home network wifi, reconnect the network drives
    # ( [ "$WPA_ID" == 'FiOS-UXB2O' ] && remotes mount ) &

    # try to connect the remotes, no matter what the network is
    remotes mount &
    
    # try to update machine date & time
    ntpdate pool.ntp.org &

    # experiment to see how to id the wired home network.
    ;;

DISCONNECTED)

    # do stuff on disconnect

    # disconnect network drives. no harm done if they aren't connected already
    remotes umount

    ;;

*)
    >&2 echo "Houston, we have a problem. Unexpected event: $2"
    ;;

esac