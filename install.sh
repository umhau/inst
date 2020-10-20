#!/bin/bash

# new structure. One install script; anything that's incompatible gets split 
# into a separate script labeled <function>.<os version>.sh.  If there's three 
# OSes, split it 3 ways. Keeps it simple, with only a little extra bookkeeping. 

osvers="$1"

case $osvers in

  ubuntu)
    echo -n "installing system with Ubuntu variations"
    ;;

  void)
    echo -n "installing system with void linux variations"
    ;;

  openbsd)
    echo -n "OpenBSD is not configured yet. Please come back later." && exit
    ;;

  *)
    echo -n "provide a correct OS version to the script" && exit
    ;;
esac

INSTALL()    { sudo install -Dv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }

bash s/autologin.$osvers.sh  # do this early, b/c the void version requires tty2

source s/packages.sh

bash s/installpkgs.$osvers.sh                  # install each package separately

bash s/femtolisp.sh                           # grab an awesome lisp interpreter

sudo usermod -aG kvm `whoami`; sudo modprobe -v kvm-intel     # qemu adjustments

bash s/folderstructure.sh                               # this seems OS-agnostic

[ "$osvers" == "void" ] && s/daemons.$osvers.sh   # e.g. ssh, print server, etc.

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
INSTALL s/thunarcustomactions.xml                 "$HOME/.config/Thunar/uca.xml"

if [ "$osvers" == "void" ] ; then
sudo install -Dv s/acpi_handler.sh                        "/etc/acpi/handler.sh"
sudo install -Dv s/display_configuration.sh                "/usr/local/bin/disp"
sudo install -Dv s/cups-files.conf                   "/etc/cups/cups-files.conf"
fi

# st and stterm need to have their names reconciled for my i3config script
[ "$osvers" == "ubuntu" ] && sudo install -Dv /usr/bin/stterm /usr/bin/st

# reboot without root password 
if ! sudo grep --quiet "/usr/bin/reboot" /etc/sudoers 2>/dev/null; then
    TEXT="`whoami` ALL = NOPASSWD: /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/zzz, /usr/bin/ZZZ"
    echo "$TEXT" | sudo EDITOR='tee -a' visudo
fi

# control the backlight
if ! grep --quiet "/sys/class/backlight" /etc/sudoers 2>/dev/null; then
    TEXT='%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/backlight/*/brightness'
    echo "$TEXT" | sudo EDITOR='tee -a' visudo
fi

# set up compact printing script tools
sudo install -Dv s/pdfjam                                "/usr/local/bin/pdfjam"
sudo install -Dv s/print_efficiently.2.sh  "/usr/local/bin/print_efficiently.sh"
sudo install -Dv s/print_efficiently_quickly.sh  "/usr/local/bin/print_efficiently_quickly.sh"

## AESTHETIC MODIFICATIONS ## ----------------------------------------------- ##

mkdir -pv $HOME/system/wallpaper/lockscreens/

sudo install -Dv s/gtk2.ini          "$HOME/.config/gtk-2.0/gtkfilechooser.ini"
sudo install -Dv s/gtk3.settings.ini       "$HOME/.config/gtk-3.0/settings.ini"
sudo install -Dv s/gtkrc2                                    "$HOME/.gtkrc-2.0"
mkdir -pv $HOME/.config/vlc; sudo install -Dv s/vlcrc      "$HOME/.config/vlc/"
sudo install -Dv s/wallpaper.sh   "$HOME/system/wallpaper/wallpaper_changer.sh"

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
