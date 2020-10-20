#!/bin/bash

# Do NOT run this script as root. It depends on using $HOME to put things where
# they go, and that WILL mess it up.

# To fix appearances after installation, use the packages lxappearance and qt5ct

## VARIABLES ## ------------------------------------------------------------ ##

NAShostname="personalstorage"

INSTALL()    { sudo install -Dv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }

## PACKAGE INSTALL ## ------------------------------------------------------ ##


source s/packages.sh

sudo apt --purge autoremove -y
sudo apt update
sudo apt upgrade -y

for pkg in "${PK[@]}";do sudo apt install -y "$pkg";done   # install separately

sudo apt --purge autoremove -y
sudo apt update
sudo apt upgrade -y

## FOLDER STRUCTURE ## ----------------------------------------------------- ##
# update xdg directories and gtk bookmarks when these change

bash s/folderstructure.sh

## MOUNT NETWORK DRIVES ## ------------------------------------------------- ##
# if the NAS is still in use, this should allow access. Remember to keep the
# folder hierarchy in sync accross files.

# bash s/networkdrives.sh || echo "connection to network drive failed"

## SYSTEM CONSTRUCTION ## --------------------------------------------------- ##

INSTALL s/nanorc                                                 "$HOME/.nanorc"
INSTALL s/bashrc.ubuntu                                          "$HOME/.bashrc"
INSTALL s/vimrc                                                   "$HOME/.vimrc"
INSTALL  s/xinitrc                                              "$HOME/.xinitrc"
INSTALL s/featherpad.conf                     "$HOME/.config/featherpad/fp.conf"
mkdir -pv $HOME/.fonts; [ -d s/fonts ] && cp -v s/fonts/*        "$HOME/.fonts/"
INSTALL  s/bash_profile                                    "$HOME/.bash_profile"
INSTALL  s/i3config                                    "$HOME/.config/i3/config"
INSTALL  s/i3status.conf                                  "$HOME/.i3status.conf"
# sudo install -Dv s/acpi_handler.sh                        "/etc/acpi/handler.sh"
# sudo install -Dv s/display_configuration.sh                "/usr/local/bin/disp"
sudo install -Dv s/mountnetworkdrives.sshfs.sh                 "/usr/local/bin/"
INSTALL s/thunarcustomactions.xml                 "$HOME/.config/Thunar/uca.xml"
# sudo install -Dv s/cups-files.conf                   "/etc/cups/cups-files.conf"
sudo install -Dv s/serialmouseconfig.sh    "/usr/local/bin/serialmouseconfig.sh"

# st and stterm need to have their names reconciled so my i3config script is 
# consistent.  
sudo install -Dv /usr/bin/stterm /usr/bin/st

# serial mouse: kensington expert mouse
# gcc s/inputattach.c -o s/inputattach
# sudo install -Dv s/65-kensingtonexpertmouse.rules           "/etc/udev/rules.d/"
# sudo install -Dv s/inputattach                                 "/usr/local/bin/"

#if [ -f s/wpa_supplicant.conf ];then
#    sudo install -Dv s/wpa_supplicant.conf "/etc/wpa_supplicant/"; fi

# automatic login 
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo rm -rf /etc/systemd/system/getty@tty1.service.d/override.conf

WRT() { echo "$1" | sudo tee -a /etc/systemd/system/getty@tty1.service.d/override.conf; }

WRT '[Service]'
WRT 'ExecStart='
WRT "ExecStart=-/sbin/agetty --noissue --autologin `whoami` %I \$TERM"
WRT 'Type=idle'

# reboot without root password 
if ! sudo grep --quiet "/usr/bin/reboot" /etc/sudoers 2>/dev/null; then
    TEXT="`whoami` ALL = NOPASSWD: /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/zzz, /usr/bin/ZZZ"
    echo "$TEXT" | sudo EDITOR='tee -a' visudo
fi

# run mouseconfig for the serial mouse without root password 
#if ! sudo grep --quiet "serialmouseconfig" /etc/sudoers 2>/dev/null; then
#    TEXT="`whoami` ALL = NOPASSWD: /usr/local/bin/serialmouseconfig.sh"
#    echo "$TEXT" | sudo EDITOR='tee -a' visudo
#fi

# RL="/etc/rc.local";                      [ ! -f $RL.bak ] && sudo cp $RL $RL.bak
# echo "(wpa_supplicant -B -i$wifidev -D$wifidriver -c/etc/wpa_supplicant/wpa_supplicant.conf) &" | sudo tee $RL
# echo "(sleep 30 && ntpdate pool.ntp.org) &"                                                     | sudo tee -a $RL
# echo "(su `whoami` -c '/usr/local/bin/mountnetworkdrives.sshfs.sh') &"                        | sudo tee -a $RL

# set up compact printing script tools
#sudo install -Dv s/pdfjam                                "/usr/local/bin/pdfjam"
#sudo install -Dv s/print_efficiently.2.sh  "/usr/local/bin/print_efficiently.sh"
#sudo install -Dv s/print_efficiently_quickly.sh  "/usr/local/bin/print_efficiently_quickly.sh"

## AESTHETIC MODIFICATIONS ## ----------------------------------------------- ##

sudo install -Dv s/gtk2.ini          "$HOME/.config/gtk-2.0/gtkfilechooser.ini"
sudo install -Dv s/gtk3.settings.ini       "$HOME/.config/gtk-3.0/settings.ini"
sudo install -Dv s/gtkrc2                                    "$HOME/.gtkrc-2.0"
mkdir -pv $HOME/.config/vlc; sudo install -Dv s/vlcrc      "$HOME/.config/vlc/"
sudo install -Dv s/wallpaper.sh   "$HOME/system/wallpaper/wallpaper_changer.sh"

# if the network drive providing the wallpaper source is available, use it
if mount | grep "/network/system" > /dev/null; then
    rsync -v --ignore-existing -r \
        /network/system/wallpaper/current $HOME/system/wallpaper/
    # cp -vr /network/system/wallpaper/current $HOME/system/wallpaper/;
fi

# multimonitor lock screen | dependencies: imagemagick i3lock
#sudo install -v s/i3lock-mm /usr/local/bin/;
#sudo chmod -v +x /usr/local/bin/i3lock-mm
#mkdir -pv $HOME/system/wallpaper/lockscreens/
#cp -v s/lockscreen.surf.png $HOME/system/wallpaper/lockscreens/surf.png

echo "done. press enter to reboot now. > "; read; sudo reboot
