#!/bin/bash

set -e
SP="$( cd "$(dirname "$0")" ; pwd -P )"
IP="$1"; UR="$2"; echo "server IP address: $IP";echo "shared username: $UR"
# "usage: void.sh <server IP> <shared username>"

## PACKAGES ## ------------------------------------------------------------- ##
# this selection is based on the gcc compiler collection, and will give errors 
# if used with the musli version

PK="$PK ntfs-3g linux-firmware linux-firmware-intel linux-firmware-network vscode"
PK="$PK xinit xorg st tmux htop curl nano nload i3 j4-dmenu-desktop i3lock feh"
PK="$PK sct spacefm qdirstat gparted geany firefox xbindkeys gimp nomacs scrot"
PK="$PK deadbeef vlc x264 ffmpeg youtube-dl qbittorrent rofi xbanish i3status"
PK="$PK wpa_gui wpa_supplicant rsync void-repo-nonfree virtualbox-ose arandr"
PK="$PK sublime-text3 sublime-merge zenmap maim qemu galculator chromium"
# PK="$PK xpdf macchanger i3status apl pandoc mirage inkscape hdparm"
# PK="$PK alsa-utils deluge deluge-gtk syncthing syncthing-gtk autorandr"

sudo xbps-install -Su; sudo xbps-install -Su; sudo xbps-install -Sy $PK

echo "exec i3"                                             > /home/$UR/.xinitrc

# install items from system/scripts/tools/ ? 

# qemu adjustments - make sure BIOS is set up for it
# sudo usermod -aG kvm $UR; sudo modprobe kvm-intel 

## FOLDER STRUCTURE ## ----------------------------------------------------- ##

mkdir -p /home/$UR/system/./downloads/../screenshots/../software/../wallpaper
mkdir -p /home/$UR/system/./virtual/../desktop/../shared/../templates
mkdir -p /home/$UR/libraries
mkdir -p /home/$UR/amusant/images/../music/../videos/../stories/../games
mkdir -p /home/$UR/intimate/accounts/../recipes/../memories/../healthcare

## GRABS FROM PRIOR COMPUTER ## -------------------------------------------- ##

mkdir -p /home/$UR/.config/i3
GB()                                                 { scp $UR@$IP:"$1" "$1"; }
GB                                                          "/home/$UR/.bashrc"
GB                                                          "/home/$UR/.nanorc"
GB                                         "/home/$UR/system/wallpaper/current"
GB                            "/home/$UR/system/wallpaper/wallpaper_changer.sh"
GB                                                           "/home/$UR/.fonts"
GB                                                   "/home/$UR/system/scripts"
GB                                                  "/home/$UR/.config/gtk-3.0"
GB                                                  "/home/$UR/.config/gtk-2.0"
GB                                                      "/home/$UR/.config/vlc"
GB                                           "/home/$UR/.config/user-dirs.dirs"
GB                                                "/home/$UR/.config/i3/config"
GB                                                   "/home/$UR/.i3status.conf"

GB()                                            { sudo scp $UR@$IP:"$1" "$1"; }
GB                                                              "/etc/rc.local"
GB                                    "/etc/wpa_supplicant/wpa_supplicant.conf"

## START DAEMONS ## -------------------------------------------------------- ##

# also: smbd udevd rpcbind dhcpcd cupsd
# sudo ln -s /etc/sv/sshd /var/service/                                   # ssh
# sudo ln -s /etc/sv/acpid /var/service/          # acpi to get suspend working
sudo ln -s /etc/sv/cupsd /var/service/                    # print server client
sudo ln -s /etc/sv/nfs-server /var/service/                               # nfs

## NOTES ## ---------------------------------------------------------------- ##

echo "done."

# modify acpi actions (lid close, power button, etc.) with /etc/acpi/handler.sh

# echo 1 > /sys/class/leds/tpacpi\:\:kbd_backlight/brightness can successfully
# modify the keyboard backlight of the x230

