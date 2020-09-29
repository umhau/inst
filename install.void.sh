#!/bin/bash

# Do NOT run this script as root. It depends on using $HOME to put things where
# they go, and that WILL mess it up.

# To fix appearances after installation, use the packages lxappearance and qt5ct

# you MUST be logged in at tty2, NOT tty1, when this is run, due to the process
# of installing the autologin system. It messes with what the tty1 does.
# stop the script with ctrl-z

# TODO: the disp function DOES NOT WORK.

# TODO: for future-proofing, separate out the parts of the script that depend 
# on external devices, like the personalstorage server. That should be a 
# separate config dedicated to setting up a device with that server. The 
# trouble will be in choosing the point at which to run that command, and 
# whether or not it should install its own packages. Maybe add a query list
# to the top of the install.sh file, to make sure other things have been set
# up first?  Make install.sh the last thing you run?

# TODO: add a command line option for whether I plan to use wifi.  Rather not
# install and turn on wpa_supplicant if the computer will never use it. This 
# would correspond to checking if I'm installing to a desktop or not.

# TODO: put most of the information on a second tty.  errors on one, verbosity
# on another.  1>/dev/tty3, 2>/dev/tty4, etc.

# TODO: install a proper ntp daemon. See: https://wiki.voidlinux.org/NTP

# TODO: make sure display configuration is applicable to the desktop system.

## STATUS CHECK ## --------------------------------------------------------- ##

# this is for the autologin, since I'm altering the behavior of tty1.
if tty | grep -q 'tty1'; then echo "use tty2!"; exit; fi

## VARIABLES ## ------------------------------------------------------------ ##

NAShostname="personalstorage"
wifidev="wlp3s0"
wifidriver="nl80211"

INSTALL()    { sudo install -Dv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }

## PACKAGE INSTALL ## ------------------------------------------------------ ##

# purge old kernels: docs.voidlinux.org/config/kernel.html
sudo vkpurge rm all

# make sure xbps is updated
sudo xbps-install -Su xbps; sudo xbps-install -Su xbps

# install each package separately to avoid an error killing the whole process
source s/packages.sh; for p in "${PK[@]}"; do sudo xbps-install -y "$p"; done

# reconfigure virtualbox here (is the script lost forever?)
echo "FIND VIRTUALBOX RECONFIGURATION SCRIPT"

# qemu adjustments
sudo usermod -aG kvm `whoami`; sudo modprobe -v kvm-intel    

## FOLDER STRUCTURE ## ----------------------------------------------------- ##
# update xdg directories and gtk bookmarks when these change

bash s/folderstructure.sh

## DAEMONS INITIALIZATION ## ----------------------------------------------- ##

# also: smbd udevd  dhcpcd cupsd | NFS: nfs-server statd rpcbind
[ ! -d /var/service/sshd ] && sudo ln -sv /etc/sv/sshd /var/service/      # ssh
[ ! -d /var/service/acpid ] && sudo ln -sv /etc/sv/acpid /var/service/ #suspend
[ ! -d /var/service/cupsd ] && sudo ln -sv /etc/sv/cupsd /var/service/  # print
# also ntpd, after the dependency (ntp?) is installed

## MOUNT NETWORK DRIVES ## ------------------------------------------------- ##
# if the NAS is still in use, this should allow access. Remember to keep the
# folder hierarchy in sync accross files.

# bash s/networkdrives.sh || echo "connection to network drive failed"

## SYSTEM CONSTRUCTION ## --------------------------------------------------- ##

INSTALL s/nanorc                                                 "$HOME/.nanorc"
INSTALL s/bashrc                                                 "$HOME/.bashrc"
INSTALL s/vimrc                                                   "$HOME/.vimrc"
INSTALL  s/xinitrc                                              "$HOME/.xinitrc"
INSTALL s/featherpad.conf                     "$HOME/.config/featherpad/fp.conf"
mkdir -pv $HOME/.fonts; [ -d s/fonts ] && cp -v s/fonts/*        "$HOME/.fonts/"
INSTALL  s/bash_profile                                    "$HOME/.bash_profile"
INSTALL  s/i3config                                    "$HOME/.config/i3/config"
INSTALL  s/i3status.conf                                  "$HOME/.i3status.conf"
sudo install -Dv s/acpi_handler.sh                        "/etc/acpi/handler.sh"
sudo install -Dv s/display_configuration.sh                "/usr/local/bin/disp"
sudo install -Dv s/mountnetworkdrives.sshfs.sh                 "/usr/local/bin/"
INSTALL s/thunarcustomactions.xml                 "$HOME/.config/Thunar/uca.xml"
sudo install -Dv s/cups-files.conf                   "/etc/cups/cups-files.conf"
sudo install -Dv s/serialmouseconfig.sh    "/usr/local/bin/serialmouseconfig.sh"


# serial mouse: kensington expert mouse
# gcc s/inputattach.c -o s/inputattach
# sudo install -Dv s/65-kensingtonexpertmouse.rules           "/etc/udev/rules.d/"
# sudo install -Dv s/inputattach                                 "/usr/local/bin/"

# TODO: include supplicant.conf in the git repo, but encrypt it.
if [ -f s/wpa_supplicant.conf ];then
    sudo install -Dv s/wpa_supplicant.conf "/etc/wpa_supplicant/"; fi

# automatic login | you MUST be logged in at tty2, NOT tty1, when this is run
# https://wiki.voidlinux.org/Automatic_Login_to_Graphical_Environment
if [ -d /var/service/agetty-tty1 ]; then
    sudo cp -Rv /etc/sv/agetty-tty1 /etc/sv/agetty-autologin-tty1
    CONF='/etc/sv/agetty-autologin-tty1/conf'
    echo "GETTY_ARGS=\"--autologin `whoami` --noclear\""     | sudo tee    $CONF
    echo "BAUD_RATE=38400"                                   | sudo tee -a $CONF
    echo "TERM_NAME=linux"                                   | sudo tee -a $CONF
    sudo rm -v /var/service/agetty-tty1
    sudo ln -sv /etc/sv/agetty-autologin-tty1 /var/service
fi

# reboot without root password 
if ! grep --quiet "/usr/bin/reboot" /etc/sudoers 2>/dev/null; then
    TEXT='%wheel ALL=(ALL) NOPASSWD: /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/zzz, /usr/bin/ZZZ'
    echo "$TEXT" | sudo EDITOR='tee -a' visudo
fi

# control the backlight
if ! grep --quiet "/sys/class/backlight" /etc/sudoers 2>/dev/null; then
    TEXT='%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/backlight/*/brightness'
    echo "$TEXT" | sudo EDITOR='tee -a' visudo
fi

    

# run mouseconfig for the serial mouse without root password 
#if ! grep --quiet "serialmouseconfig" /etc/sudoers 2>/dev/null; then
#    TEXT='%wheel ALL=(ALL) NOPASSWD: /usr/local/bin/serialmouseconfig.sh'
#    echo "$TEXT" | sudo EDITOR='tee -a' visudo
#fi

# RL="/etc/rc.local";                      [ ! -f $RL.bak ] && sudo cp $RL $RL.bak
# echo "(wpa_supplicant -B -i$wifidev -D$wifidriver -c/etc/wpa_supplicant/wpa_supplicant.conf) &" | sudo tee $RL
# echo "(sleep 30 && ntpdate pool.ntp.org) &"                                                     | sudo tee -a $RL
# echo "(su `whoami` -c '/usr/local/bin/mountnetworkdrives.sshfs.sh') &"                        | sudo tee -a $RL

# set up compact printing script tools
sudo install -Dv s/pdfjam                                "/usr/local/bin/pdfjam"
sudo install -Dv s/print_efficiently.2.sh  "/usr/local/bin/print_efficiently.sh"
sudo install -Dv s/print_efficiently_quickly.sh  "/usr/local/bin/print_efficiently_quickly.sh"

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

# put a menu that organizes and lists programs down in the tray
git clone https://github.com/trizen/menutray.git
sudo install menutray/menutray /usr/local/bin/
mkdir -p /home/`whoami`/.config/menutray
sudo install -v menutray/schema.pl /home/`whoami`/.config/menutray/

# multimonitor lock screen | dependencies: imagemagick i3lock
sudo install -v s/i3lock-mm /usr/local/bin/;
sudo chmod -v +x /usr/local/bin/i3lock-mm
mkdir -pv $HOME/system/wallpaper/lockscreens/
cp -v s/lockscreen.surf.png $HOME/system/wallpaper/lockscreens/surf.png

echo "done. press enter to reboot now. > "; read; sudo reboot
