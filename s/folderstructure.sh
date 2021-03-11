#!/bin/bash

rm -rf Desktop Documents Downloads Music Pictures Public Templates Videos

netmount='/net'
homedir="/home/`whoami`"
INSTALL()    { sudo install -Dv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }

username=`whoami`
sudo mkdir -p $netmount ; sudo chown -v $username:$username $netmount


# create new folder system
mkdir -vp $homedir/system
mkdir -vp $homedir/system/unsorted
mkdir -vp $homedir/system/software
mkdir -vp $homedir/system/wallpaper
mkdir -vp $homedir/system/virtualmachines
mkdir -vp $homedir/system/public
mkdir -vp $homedir/system/templates
mkdir -vp $homedir/system/scripts
mkdir -vp $homedir/system/disk_images

mkdir -vp $homedir/libraries/

mkdir -vp $homedir/amusant/
mkdir -vp $homedir/amusant/images
mkdir -vp $homedir/amusant/music
mkdir -vp $homedir/amusant/videos/movies
mkdir -vp $homedir/amusant/videos/shows
mkdir -vp $homedir/amusant/stories
mkdir -vp $homedir/amusant/games

mkdir -vp $homedir/private/

sudo mkdir -vp $netmount/
sudo mkdir -vp $netmount/amusant
sudo mkdir -vp $netmount/private
sudo mkdir -vp $netmount/system
sudo mkdir -vp $netmount/libraries
sudo mkdir -vp $netmount/settings

# if the /network dir is empty (i.e. unmounted), then fix the permissions
if [ ! "$(ls -A $netmount)" ]; then
    sudo chown -Rv `whoami`:`whoami` /mnt/net/; sudo chmod -Rv 755 /mnt/net/; fi

XR=/etc/xdg/user-dirs.defaults
XU=$homedir/.config/user-dirs.defaults
TP=/tmp/xdg.t

echo "XDG_MUSIC_DIR=\"$homedir/amusant/music\""                            > $TP
echo "XDG_PUBLICSHARE_DIR=\"$homedir/system/public\""                     >> $TP
echo "XDG_TEMPLATES_DIR=\"$homedir/system/templates\""                    >> $TP
echo "XDG_VIDEOS_DIR=\"$homedir/amusant/videos\""                         >> $TP
echo "XDG_DOCUMENTS_DIR=\"$homedir/libraries\""                           >> $TP
echo "XDG_PICTURES_DIR=\"$homedir/unsorted\""                             >> $TP
echo "XDG_DOWNLOAD_DIR=\"$homedir/unsorted\""                             >> $TP
echo "XDG_DESKTOP_DIR=\"$homedir/unsorted\""                              >> $TP
sudo install -Dv $TP                               "/etc/xdg/user-dirs.defaults"
INSTALL $TP                                   "$homedir/.config/user-dirs.defaults"

# # alternate version, possibly ubuntu-specific, possibly an updated syntax
# XR=/etc/xdg/user-dirs.defaults;XU=$homedir/.config/user-dirs.defaults;TP=/tmp/xdg.t
# echo "DESKTOP=unsorted"                                                 >> $TP
# echo "DOWNLOAD=unsorted"                                                >> $TP
# echo "TEMPLATES=system/templates"                                         >> $TP
# echo "PUBLICSHARE=system/public"                                          >> $TP
# echo "DOCUMENTS=libraries"                                                >> $TP
# echo "MUSIC=amusant/music"                                                >> $TP
# echo "PICTURES=unsorted"                                                  >> $TP
# echo "VIDEOS=amusant/videos"                                              >> $TP
# sudo install -Dv $TP                               "/etc/xdg/user-dirs.defaults"
# INSTALL()    { sudo install -Dv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }
# INSTALL $TP                                   "$homedir/.config/user-dirs.defaults"

sudo chown -Rv `whoami`:`whoami` $homedir/.config/gtk-3.0
mkdir -pv $homedir/.config/gtk-3.0/
G3B=$homedir/.config/gtk-3.0/bookmarks

echo "file://$homedir/unsorted unsorted"                                  > $G3B
echo "file://$homedir/libraries libraries"                               >> $G3B
echo "file://$homedir/private private"                                   >> $G3B
echo "file://$homedir/system system"                                     >> $G3B
echo "file://$homedir/amusant amusant"                                   >> $G3B

echo "file://$netmount  share drive"                                    >> $G3B

echo "file://$netmount/libraries  libraries"                            >> $G3B
echo "file://$netmount/private  private"                                >> $G3B
echo "file://$netmount/system  system"                                  >> $G3B
echo "file://$netmount/amusant  amusant"                                >> $G3B
echo "file://$netmount/settings  settings"                              >> $G3B
