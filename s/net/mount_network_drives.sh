#!/bin/bash

# This should only require sudo on the first use. After that, nothing requires
# more than user permissions.  Hence, suitable for the i3config file.

## define network mounts ## ----------------------------------------------------

mpl="/mnt/net"                  # mount points location: alternately "/network/"

declare -A network_locations=(

    ["networkstorage:/massivestorage/amusant"]="$mpl/amusant"
    ["networkstorage:/massivestorage/system"]="$mpl/system"
    ["networkstorage:/massivestorage/libraries"]="$mpl/libraries"
    ["networkstorage:/massivestorage/private"]="$mpl/private"
    ["networkstorage:/massivestorage/settings"]="$mpl/settings"

    ["dev:libraries"]="$mpl/dev"

)


## ensure system is properly configured ## -------------------------------------

[ -f /usr/bin/sshfs ] || sudo apt install sshfs || sudo xbps-install -S sshfs

if ! grep -i "^user_allow_other" /etc/fuse.conf
then echo "user_allow_other" | sudo tee -a /etc/fuse.conf; fi


## set relevant variables ## ---------------------------------------------------

usr=`whoami`

OPTIONS="-o allow_root,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3"


## fix local mount points ## ---------------------------------------------------

for mt in ${!network_locations[@]};do

  mp="${network_locations[$mt]}"

  [ -d $mp ] || mkdir -p $mp || sudo mkdir -p $mp && sudo chown $usr:$usr $mp

done


## ensure access to network systems ## -----------------------------------------

for mt in ${!network_locations[@]};do

  srv="${mt%%:*}"                                                  # server name

  [ -f /home/$usr/.ssh/id_rsa ] || ssh-keygen   # create ssh key, only if needed

  auth=`ssh $usr@$srv -o PasswordAuthentication=no echo 0 2>/dev/null || echo 1`

  [ "$auth" == '1' ] && ssh-copy-id $usr@$srv # if password is needed upload key

done


## mount network drives ## -----------------------------------------------------

for mt in ${!network_locations[@]};do

  echo "-----------------------------------------------------------------------"

  if mount | grep "$mt"; then echo "$mt already mounted" && continue; fi

  mp="${network_locations[$mt]}"                             # local mount point

  srv="${mt%%:*}"                                                  # server name

  echo "network mount location: $mt"
  echo "remote server: $srv"
  echo "local mount point: $mp"

  sshfs $OPTIONS "$mt" "$mp"

done

echo   "-----------------------------------------------------------------------"
