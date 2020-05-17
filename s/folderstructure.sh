#!/bin/bash

# if present, delete preexisting folders
[ -d ~/Desktop ] &&  rm -rf ~/Desktop
[ -d ~/Documents ] &&  rm -rf ~/Documents
[ -d ~/Downloads ] && rm -rf ~/Downloads
[ -d ~/Music ] &&     rm -rf ~/Music
[ -d ~/Pictures ] &&  rm -rf ~/Pictures
[ -d ~/Public ] &&    rm -rf ~/Public
[ -d ~/Templates ] && rm -rf ~/Templates
[ -d ~/Videos ] &&    rm -rf ~/Videos

# create new folder system
mkdir -vp $HOME/system
mkdir -vp $HOME/system/software
mkdir -vp $HOME/system/wallpaper
mkdir -vp $HOME/system/virtualmachines
mkdir -vp $HOME/system/public
mkdir -vp $HOME/system/templates
mkdir -vp $HOME/system/scripts
mkdir -vp $HOME/system/disk_images

mkdir -vp $HOME/libraries/

mkdir -vp $HOME/unsorted

mkdir -vp $HOME/amusant/
mkdir -vp $HOME/amusant/images
mkdir -vp $HOME/amusant/music
mkdir -vp $HOME/amusant/videos
mkdir -vp $HOME/amusant/stories
mkdir -vp $HOME/amusant/games

mkdir -vp $HOME/private/
mkdir -vp $HOME/private/notes

sudo mkdir -vp /network/
sudo mkdir -vp /network/amusant
sudo mkdir -vp /network/intimate
sudo mkdir -vp /network/system
sudo mkdir -vp /network/libraries
sudo mkdir -vp /network/settings

# if the /network dir is empty (i.e. unmounted), then fix the permissions
if [ ! "$(ls -A /network)" ]; then
    sudo chown -Rv `whoami`:`whoami` /network/; sudo chmod -Rv 755 /network/; fi

# set up XDG directories
#XR=/etc/xdg/user-dirs.defaults;XU=$HOME/.config/user-dirs.defaults;TP=/tmp/xdg.t
#echo "XDG_MUSIC_DIR=\"$HOME/amusant/music\""                               > $TP
#echo "XDG_PUBLICSHARE_DIR=\"$HOME/system/public\""                        >> $TP
#echo "XDG_TEMPLATES_DIR=\"$HOME/system/templates\""                       >> $TP
#echo "XDG_VIDEOS_DIR=\"$HOME/amusant/videos\""                            >> $TP
#echo "XDG_DOCUMENTS_DIR=\"$HOME/libraries\""                              >> $TP
#echo "XDG_PICTURES_DIR=\"$HOME/unsorted\""                                >> $TP
#echo "XDG_DOWNLOAD_DIR=\"$HOME/unsorted\""                                >> $TP
#echo "XDG_DESKTOP_DIR=\"$HOME/unsorted\""                                 >> $TP
#sudo install -Dv $TP                               "/etc/xdg/user-dirs.defaults"
#INSTALL $TP                                   "$HOME/.config/user-dirs.defaults"

# alternate version, possibly ubuntu-specific, possibly an updated syntax
XR=/etc/xdg/user-dirs.defaults;XU=$HOME/.config/user-dirs.defaults;TP=/tmp/xdg.t
echo "DESKTOP=unsorted"                                                    > $TP
echo "DOWNLOAD=unsorted"                                                  >> $TP
echo "TEMPLATES=system/templates"                                         >> $TP
echo "PUBLICSHARE=system/public"                                          >> $TP
echo "DOCUMENTS=libraries"                                                >> $TP
echo "MUSIC=amusant/music"                                                >> $TP
echo "PICTURES=unsorted"                                                  >> $TP
echo "VIDEOS=amusant/videos"                                              >> $TP
sudo install -Dv $TP                               "/etc/xdg/user-dirs.defaults"
INSTALL()    { sudo install -Dv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }
INSTALL $TP                                   "$HOME/.config/user-dirs.defaults"

# set up bookmarks
sudo chown -Rv `whoami`:`whoami` $HOME/.config/gtk-3.0
mkdir -pv $HOME/.config/gtk-3.0/; G3B=$HOME/.config/gtk-3.0/bookmarks
echo "file:///home/`whoami`/unsorted unsorted"                           >> $G3B
echo "file:///home/`whoami`/libraries libraries"                          > $G3B
echo "file:///home/`whoami`/private private"                             >> $G3B
echo "file:///home/`whoami`/system system"                               >> $G3B
echo "file:///home/`whoami`/amusant amusant"                             >> $G3B
echo "file:///network/libraries  libraries"                            >> $G3B
echo "file:///network/intimate  intimate"                              >> $G3B
echo "file:///network/system  system"                                  >> $G3B
echo "file:///network/amusant  amusant"                                >> $G3B
echo "file:///network/settings  settings"                              >> $G3B
