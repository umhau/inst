#!/bin/bash

# new structure. One install script; anything that's incompatible gets split 
# into a separate script labeled <function>.<os version>.sh.  If there's three 
# OSes, split it 3 ways. Keeps it simple, with only a little extra bookkeeping. 


## -- [ funcs & vars & initial checks ] --- --------------------------------- ##

INSTALL()    { sudo install -Dv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }
COPY()            { sudo cp -rv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }

osvers="$1"

if tty | grep -q 'tty1'; then echo "must use tty2!"; exit; fi

[ "`whoami`" == 'root' ] && echo "to run as root, remove this message" && exit


## -- [ OS check ] ---------------------------------------------------------- ##

case $osvers in

  ubuntu)
    echo "installing system with Ubuntu variations"
    ;;

  void)
    echo "installing system with void linux variations"
    ;;

  openbsd)
    echo "OpenBSD is not configured yet. Please come back later." && exit
    ;;

  freebsd)
    echo "New hotness isn't here yet. Try again later." && exit
    ;;

  *)
    echo "provide a correct OS version to the script" && exit
    ;;

esac

echo "available wireless interfaces:"
iw dev | awk '$1=="Interface"{print $2}'
echo -n "enter the interface name to activate automatically > "
read wirelessinterface ; wirelessinterface=$(echo $wirelessinterface | xargs)
echo "confirm interface $wirelessinterface [enter/ctrl-c] > "

## -- [ package & software installation ] ----------------------------------- ##

bash s/installpkgs.$osvers.sh # with_extras        # install packages separately
sudo usermod -aG kvm `whoami`; sudo modprobe -v kvm-intel     # qemu adjustments
bash s/femtolisp.sh                           # grab an awesome lisp interpreter

# set up compact printing script tools
sudo install -Dv s/printing/pdfjam                       "/usr/local/bin/pdfjam"
sudo install -Dv s/printing/print_efficiently.2.sh  "/usr/local/bin/pdfprint.sh"

st and stterm need to have their names reconciled for my i3config script
[ "$osvers" == "ubuntu" ] && sudo install -Dv /usr/bin/stterm /usr/bin/st

bash s/menutray/menutray.inst.sh # a tray menu that organizes and lists programs


## -- [ system construction ] ----------------------------------------------- ##
# the system won't function properly without this stuff

sudo install s/rc.local /etc/rc.local           # the startup programs pre-login
sudo sed -i "s/wlp3s0/$wirelessinterface/g" /etc/rc.local     # use correct interface

bash s/autologin.$osvers.sh  # do this early, b/c the void version requires tty2
[ "$osvers" == "void" ] && bash s/void_daemons.sh       # ssh, print server, etc
INSTALL  s/xinitrc "$HOME/.xinitrc"                                    # exec i3
bash s/folderstructure.sh                               # this seems OS-agnostic
bash s/sudo_reboot.sh                             # reboot without root password 
bash s/sudo_backlight.sh                                 # control the backlight
bash s/multimonitor_lock_screen.sh                                 # lock screen
vboxmanage setproperty machinefolder /home/`whoami`/system/virtualmachines

## -- [ network interactions ] ---------------------------------------------- ##

INSTALL s/net/remotes                                     /usr/local/bin/remotes
remotes configure              # set up passwordless login to the listed servers

INSTALL s/net/net_handler.sh                         /etc/network/net_handler.sh
INSTALL s/net/wpa_supplicant.conf        /etc/wpa_supplicant/wpa_supplicant.conf


## -- [ aesthetic modifications ] ------------------------------------------- ##
# the system won't look nice or be easy to use without this stuff

INSTALL s/nanorc                                                 "$HOME/.nanorc"
sudo cp -rv s/geany "$HOME/.config/" && \
  sudo chown -v `whoami`:`whoami` $HOME/.config/geany
INSTALL s/bashrc.$osvers                                         "$HOME/.bashrc"
INSTALL s/vimrc                                                   "$HOME/.vimrc"
INSTALL s/featherpad.conf                     "$HOME/.config/featherpad/fp.conf"
mkdir -pv $HOME/.fonts; [ -d s/fonts ] && cp -v s/fonts/*        "$HOME/.fonts/"
INSTALL s/bash_profile                                     "$HOME/.bash_profile"
INSTALL s/i3config                                     "$HOME/.config/i3/config"
INSTALL s/i3status.conf                                   "$HOME/.i3status.conf"
INSTALL s/thunarcustomactions.xml                 "$HOME/.config/Thunar/uca.xml"
bash s/git_config.sh                                  # set global git variables

mkdir -pv $HOME/system/wallpaper/lockscreens/

sudo install -Dv s/gtk2.ini           "$HOME/.config/gtk-2.0/gtkfilechooser.ini"
sudo install -Dv s/gtk3.settings.ini        "$HOME/.config/gtk-3.0/settings.ini"
sudo install -Dv s/gtkrc2                                     "$HOME/.gtkrc-2.0"
mkdir -pv $HOME/.config/vlc; sudo install -Dv s/vlcrc       "$HOME/.config/vlc/"
sudo install -Dv s/wallpaper.sh    "$HOME/system/wallpaper/wallpaper_changer.sh"

## -- [ daemons & hardware management ] ------------------------------------- ##

if [ "$osvers" == "void" ] ; then
sudo install -Dv s/acpi_handler.sh                        "/etc/acpi/handler.sh"
sudo install -Dv s/display_configuration.sh                "/usr/local/bin/disp"
sudo install -Dv s/cups-files.conf                   "/etc/cups/cups-files.conf"
fi

## -- [ final touches ] ----------------------------------------------------- ##

echo "done. press enter to reboot now. > "; read; sudo reboot
