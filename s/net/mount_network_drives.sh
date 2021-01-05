#!/bin/bash

mpl="/mnt/net"                  # mount_points_location: alternately "/network/"
me=`whoami`

declare -A network_locations=(

    ["networkstorage:/massivestorage/amusant"]="$mpl/amusant"
    ["networkstorage:/massivestorage/system"]="$mpl/system"
    ["networkstorage:/massivestorage/libraries"]="$mpl/libraries"
    ["networkstorage:/massivestorage/private"]="$mpl/private"
    ["networkstorage:/massivestorage/settings"]="$mpl/settings"

    ["dev:libraries"]="$mpl/dev"

)

OPTIONS="-o allow_root,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3"

# allow_root:   otherwise any command invoking sudo and involving the sshfs 
# directory will fail.

# reconnect,ServerAliveInterval=15,ServerAliveCountMax=3: this is supposed to 
# help the drive respond to a lost connection, and either give an IO error
# (after trying 3 times at 15 second intervals to find the network drive) or
# reconnect to the drive.  It should prevent programs from hanging (like MS
# Code was doing)
# https://serverfault.com/questions/6709/sshfs-mount-that-survives-disconnect

for mt in ${!network_locations[@]};do

  mp="${network_locations[$mt]}"                             # local mount point
  # if the folder is missing, create it; if the user cannot, use sudo
  [ -d $mp ] || mkdir -p $mp || sudo mkdir -p $mp && sudo chown $me:$me $mp


  srv="${mt%%:*}"                                      # extract the server name
  auth=`ssh $me@$srv -o PasswordAuthentication=no echo 0 2>/dev/null || echo 1`
  [ -f /home/$me/.ssh/id_rsa ] || ssh-keygen    # create ssh key, only if needed
  [ "$auth" == '1' ] && ssh-copy-id $me@$srv # if password is needed, upload key

  if mount | grep "$mt"; then continue; fi                     # already mounted

  sshfs $OPTIONS "$mt" "$mp"

done

