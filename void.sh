#!/bin/bash
set -e ; sudo ls &>/dev/null

SP="$( cd "$(dirname "$0")" ; pwd -P )"

PR="$1"; UR="$2"; 
[ -z "$2" ] && echo "use: void.sh <server hostname> <shared username>" && exit
echo "server hostname: $PR";echo "shared username: $UR";echo -n "ready? >";read

## PACKAGES ## ------------------------------------------------------------- ##

PK="$PK ntfs-3g linux-firmware "
# PK="$PK linux-firmware-intel linux-firmware-network vscode"
PK="$PK xinit xorg st tmux htop curl nano nload i3 j4-dmenu-desktop i3lock feh"
PK="$PK sct spacefm qdirstat gparted geany firefox xbindkeys gimp nomacs scrot"
PK="$PK deadbeef vlc x264 ffmpeg youtube-dl qbittorrent rofi xbanish"
PK="$PK wpa_gui wpa_supplicant rsync void-repo-nonfree virtualbox-ose arandr"
PK="$PK sublime-text3 sublime-merge zenmap maim qemu galculator chromium"
# PK="$PK xpdf macchanger i3status apl pandoc mirage inkscape hdparm"
# PK="$PK alsa-utils deluge deluge-gtk syncthing syncthing-gtk autorandr"

sudo xbps-install -Su; sudo xbps-install -Su; sudo xbps-install -S $PK

echo "exec i3"                                             > /home/$UR/.xinitrc

# install items from system/scripts/tools/ ? 

## FOLDER STRUCTURE ## ----------------------------------------------------- ##

mkdir -p /home/$UR/system/./downloads/../screenshots/../software/../wallpaper
mkdir -p /home/$UR/system/./virtual/../desktop/../shared/../templates
mkdir -p /home/$UR/libraries
mkdir -p /home/$UR/amusant/images/../music/../videos/../stories/../games
mkdir -p /home/$UR/intimate/accounts/../recipes/../memories/../healthcare

## GRABS FROM PRIOR COMPUTER ## -------------------------------------------- ##

GB()                     { sudo rsync -ah --info=progress2 $UR@$PR:"$1" "$1"; }
GB                                                          "/home/$UR/.bashrc"
GB                                                          "/home/$UR/.nanorc"
GB                                           "/home/$UR/.config/user-dirs.dirs"
GB                                                "/home/$UR/.config/i3/config"
GB                                                   "/home/$UR/.i3status.conf"
GB                                                              "/etc/rc.local"
GB                                    "/etc/wpa_supplicant/wpa_supplicant.conf"
GB                                         "/home/$UR/system/wallpaper/current"
GB                                                           "/home/$UR/.fonts"
GB                                                   "/home/$UR/system/scripts"
GB                                                  "/home/$UR/.config/gtk-3.0"
GB                                                  "/home/$UR/.config/gtk-2.0"
GB                                                      "/home/$UR/.config/vlc"


## START DAEMONS ## -------------------------------------------------------- ##

# also: smbd udevd rpcbind dhcpcd cupsd
sudo ln -s /etc/sv/sshd /var/service/                                     # ssh
sudo ln -s /etc/sv/acpid /var/service/            # acpi to get suspend working
sudo ln -s /etc/sv/cupsd /var/service/                    # print server client
sudo ln -s /etc/sv/nfs-server /var/service/                               # nfs


## NOTES ## ---------------------------------------------------------------- ##

# modify acpi actions (lid close, power button, etc.) with /etc/acpi/handler.sh

# echo 1 > /sys/class/leds/tpacpi\:\:kbd_backlight/brightness can successfully
# modify the keyboard backlight of the x230

