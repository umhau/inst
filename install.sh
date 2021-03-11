#!/bin/bash

# new structure. One install script; anything that's incompatible gets split 
# into a separate script labeled <function>.<os version>.sh.  If there's three 
# OSes, split it 3 ways. Keeps it simple, with only a little extra bookkeeping. 


## -- [ funcs & vars & initial checks ] --- --------------------------------- ##

user="`whoami`"

INSTALL()    { sudo install -Dv "$1" "$2"; sudo chown -Rv $user:$user $2; }
COPY()            { sudo cp -rv "$1" "$2"; sudo chown -Rv $user:$user $2; }

OSV="$1"                 # operating system version (void, ubuntu, openbsd, etc)

if tty | grep -q 'tty1'; then echo "must use tty2!"; exit; fi

[ "$user" == 'root' ] && echo "to run as root, remove this message" && exit


## -- [ OS check ] ---------------------------------------------------------- ##

case $OSV in

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

echo "available wireless interfaces:" ; iw dev | awk '$1=="Interface"{print $2}'
echo -n "enter the interface name to activate automatically > "
read wirelessinterface ; wirelessinterface=$(echo $wirelessinterface | xargs)
echo "confirm interface $wirelessinterface [enter/ctrl-c] > "
# use a bash menu to list and choose the interfaces, and set a default.

## -- [ package & software installation ] ----------------------------------- ##

bash s/installpkgs.$OSV.sh # with_extras        # install packages separately
bash s/femtolisp.sh                           # grab an awesome lisp interpreter

# set up compact printing script tools
INSTALL s/printing/pdfjam                       "/usr/local/bin/pdfjam"
INSTALL s/printing/print_efficiently.2.sh  "/usr/local/bin/pdfprint.sh"

# st and stterm need to have their names reconciled for my i3config script
[ "$OSV" == "ubuntu" ] && sudo install -Dv /usr/bin/stterm /usr/bin/st

bash s/menutray/menutray.inst.sh # a tray menu that organizes and lists programs

## -- [ system construction ] ----------------------------------------------- ##
# the system won't function properly without this stuff

echo "`whoami`" | sudo tee > /etc/defaultuser       # no need for hardcoded user

sudo install s/rc.local /etc/rc.local        # start programs as root, pre-login

sudo sed -i "s/wlp3s0/$wirelessinterface/g" /etc/rc.local  # set correct default

INSTALL  s/xinitrc "$HOME/.xinitrc"                                    # exec i3
bash s/folderstructure.sh                               # this seems OS-agnostic
bash s/sudo_reboot.sh                             # reboot without root password 
bash s/sudo_backlight.sh                                 # control the backlight

sudo install -v s/i3lock-mm           /usr/local/bin/i3lock-mm
sudo install -v s/screenlock.sh       /usr/local/bin/screenlock.sh
sudo install -v s/lockscreen.surf.png /etc/lockscreen.surf.png

VBoxManage setproperty machinefolder $HOME/system/virtualmachines   #vbox folder
sudo usermod -aG kvm $user; sudo modprobe -v kvm-intel        # qemu adjustments

bash s/autologin.$OSV.sh   # automatically login, assume current user is default

if   [ "$OSV" == "void" ] ; then
  bash s/void_daemons.sh                                # ssh, print server, etc
  INSTALL s/acpi_handler.sh                      "/etc/acpi/handler.sh"
  INSTALL s/cups-files.conf                 "/etc/cups/cups-files.conf"
fi

## -- [ network interactions ] ---------------------------------------------- ##

INSTALL s/net/remotes /usr/local/bin/remotes 
remotes configure
remotes mount 

INSTALL s/net/net_handler.sh                         /etc/network/net_handler.sh
INSTALL s/net/wpa_supplicant.conf        /etc/wpa_supplicant/wpa_supplicant.conf

## -- [ aesthetic modifications ] ------------------------------------------- ##
# the system won't look nice or be easy to use without this stuff

INSTALL s/editors/nanorc                                         "$HOME/.nanorc"
COPY    s/editors/geany                                    "$HOME/.config/geany"
INSTALL s/editors/vimrc                                           "$HOME/.vimrc"
INSTALL s/editors/featherpad.conf             "$HOME/.config/featherpad/fp.conf"
INSTALL s/editors/vscode.json      "$HOME/.config/Code - OSS/User/settings.json"

COPY    s/fonts                                                  "$HOME/.fonts/"
[ ! -f ~/.gitconfig ] && bash s/git_config.sh         # set global git variables

INSTALL s/bashrc.$OSV                                            "$HOME/.bashrc"
INSTALL s/bash_profile                                     "$HOME/.bash_profile"

INSTALL s/i3config                                     "$HOME/.config/i3/config"
INSTALL s/i3status.conf                                   "$HOME/.i3status.conf"

INSTALL s/thunarcustomactions.xml                 "$HOME/.config/Thunar/uca.xml"

INSTALL s/wallpaper_changer.sh    "$HOME/system/wallpaper/wallpaper_changer.sh"

[ ! -d "$HOME/system/wallpaper/current" ] && 
  { cp -rv /net/system/wallpaper/current $HOME/system/wallpaper/ || true ; }

INSTALL s/screenshot_shortcut.sh           /usr/local/bin/screenshot_shortcut.sh

INSTALL s/gtk2.ini           "$HOME/.config/gtk-2.0/gtkfilechooser.ini"
INSTALL s/gtk3.settings.ini        "$HOME/.config/gtk-3.0/settings.ini"
INSTALL s/gtkrc2                                     "$HOME/.gtkrc-2.0"

mkdir -pv $HOME/.config/vlc; sudo install -Dv s/vlcrc       "$HOME/.config/vlc/"


## -- [ final touches ] ----------------------------------------------------- ##

echo "done. press enter to reboot now. > "; read; sudo reboot
