#!/bin/bash

# Do NOT run this script as root. It depends on using $HOME to put things where
# they go, and that WILL mess it up.

# you MUST be logged in at tty2, NOT tty1, when this is run, due to the process
# of installing the autologin system. It messes with what the tty1 does.
# stop the script with ctrl-z

# TODO: add a check whether I'm in tty1 or tty2. 

# NOTE: I don't know if the musl edition of void can do what I need.

# TODO: for future-proofing, separate out the parts of the script that depend 
# on external devices, like the personalstorage server. That should be a 
# separate config dedicated to setting up a device with that server.

## STATUS CHECK ## --------------------------------------------------------- ##

if tty | grep -q 'tty1'; then echo "use tty2!"; exit; fi

## VARIABLES ## ------------------------------------------------------------ ##

NAShostname="personalstorage"
wifidev="wlp3s0"
wifidriver="nl80211"
# IFDIR() {}
# IFFILE() {}
# IFLINE() { if ! grep --quiet "/usr/bin/reboot" /etc/sudoers }

## PACKAGE INSTALL ## ------------------------------------------------------ ##

sudo vkpurge rm all       # purge old kernels: docs.voidlinux.org/config/kernel.html

sudo xbps-install -Su; sudo xbps-install -Su
sudo xbps-install -Sy void-repo-nonfree void-repo-multilib-nonfree void-repo-multilib

declare -a PK=(\
linux-firmware linux-firmware-intel linux-firmware-network qt5ct fuse-sshfs \
xorg-minimal xorg-fonts lxappearance faenza-icon-theme breeze-gtk \
xfe xinit st tmux htop curl nano nload i3 j4-dmenu-desktop i3lock feh \
sct qdirstat gparted firefox xbindkeys gimp nomacs scrot zenity  \
deadbeef vlc x264 ffmpeg youtube-dl qbittorrent rofi xbanish vim \
wpa_gui wpa_supplicant rsync virtualbox-ose arandr font-spleen vscode \
sublime-text3 sublime-merge zenmap maim qemu galculator chromium xpdf \
FeatherPad i3status unzip unrar p7zip font-awesome5 cifs-utils gcc \
ntfs-3g wireless_tools imagemagick nfs-utils breeze-snow-cursor-theme \
)

for package in "${PK[@]}"; do sudo xbps-install -y "$package"; done

# reconfigure virtualbox here

sudo usermod -aG kvm `whoami`; sudo modprobe -v kvm-intel    # qemu adjustments

## FOLDER STRUCTURE ## ----------------------------------------------------- ##
# update xdg directories when these change

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
sudo chown -Rv `whoami`:`whoami` /network/; sudo chmod -Rv 755 /network/

# set up XDG directories
XR=/etc/xdg/user-dirs.defaults;XU=$HOME/.config/user-dirs.defaults;TP=/tmp/xdg.t
echo "XDG_MUSIC_DIR=\"$HOME/amusant/music\""                               > $TP
echo "XDG_PUBLICSHARE_DIR=\"$HOME/system/public\""                        >> $TP
echo "XDG_TEMPLATES_DIR=\"$HOME/system/templates\""                       >> $TP
echo "XDG_VIDEOS_DIR=\"$HOME/amusant/videos\""                            >> $TP
echo "XDG_DOCUMENTS_DIR=\"$HOME/libraries\""                              >> $TP
echo "XDG_PICTURES_DIR=\"$HOME/unsorted\""                                >> $TP
echo "XDG_DOWNLOAD_DIR=\"$HOME/unsorted\""                                >> $TP
echo "XDG_DESKTOP_DIR=\"$HOME/unsorted\""                                 >> $TP
sudo install -Dv $TP                               "/etc/xdg/user-dirs.defaults"
INSTALL $TP                                   "$HOME/.config/user-dirs.defaults"

## DAEMONS INITIALIZATION ## ----------------------------------------------- ##

# also: smbd udevd  dhcpcd cupsd | NFS: nfs-server statd rpcbind
[ ! -d /var/service/sshd ] && sudo ln -sv /etc/sv/sshd /var/service/      # ssh
[ ! -d /var/service/acpid ] && sudo ln -sv /etc/sv/acpid /var/service/ #suspend
[ ! -d /var/service/cupsd ] && sudo ln -sv /etc/sv/cupsd /var/service/  # print

## MOUNT NETWORK DRIVES ## ------------------------------------------------- ##
# if the NAS is still in use, this should allow access. Remember to keep the
# folder hierarchy in sync accross files.

# set up passwordless ssh, so that I can use sshfs to access storage server
[ ! -f $HOME/.ssh/sshfs.key ] && \
    ssh-keygen -fv $HOME/.ssh/sshfs.key \
    ssh-copy-id -i $HOME/.ssh/sshfs.key.pub `whoami`@$NAShostname

[ ! -f /etc/fuse.conf.bak ] && sudo cp /etc/fuse.conf /etc/fuse.conf.bak
echo "user_allow_other" | sudo tee /etc/fuse.conf # required for allow_root

mkdir -pv $HOME/.ssh; CONFIG=$HOME/.ssh/config
echo "Host $NAShostname"                                               > $CONFIG
echo "HostName $NAShostname"              >> $CONFIG # alternately an IP address
echo "User `whoami`"                                                  >> $CONFIG

RL="/etc/rc.local";                      [ ! -f $RL.bak ] && sudo cp $RL $RL.bak
echo "(wpa_supplicant -B -i$wifidev -D$wifidriver -c/etc/wpa_supplicant/wpa_supplicant.conf) &" | sudo tee $RL
echo "(sleep 30 && ntpdate pool.ntp.org) &"                                                     | sudo tee -a $RL
# echo "(su `whoami` -c '/usr/local/bin/mountnetworkdrives.sshfs.sh') &"                        | sudo tee -a $RL

## SYSTEM CONSTRUCTION ## --------------------------------------------------- ##

INSTALL()    { sudo install -Dv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }
INSTALL s/nanorc                                                 "$HOME/.nanorc"
INSTALL s/bashrc                                                 "$HOME/.bashrc"
INSTALL  s/xinitrc                                              "$HOME/.xinitrc"
mkdir -pv $HOME/.fonts; [ -d s/fonts ] && cp -v s/fonts/*        "$HOME/.fonts/"
INSTALL  s/bash_profile                                    "$HOME/.bash_profile"
INSTALL  s/i3config                                    "$HOME/.config/i3/config"
INSTALL  s/i3status.conf                                  "$HOME/.i3status.conf"
sudo install -Dv s/acpi_handler.sh                        "/etc/acpi/handler.sh"
sudo install -Dv s/display_configuration.sh                "/usr/local/bin/disp"
sudo install -Dv s/mountnetworkdrives.sshfs.sh                 "/usr/local/bin/"
sudo install -Dv s/thunarcustomactions.xml        "$HOME/.config/Thunar/uca.xml"

# serial mouse: kensington expert mouse
gcc s/inputattach.c -o s/inputattach
# sudo install -Dv s/65-kensingtonexpertmouse.rules           "/etc/udev/rules.d/"
sudo install -Dv s/inputattach                                 "/usr/local/bin/"

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

# reboot without root password | this doesn't work yet
if ! grep --quiet "/usr/bin/reboot" /etc/sudoers; then
    TEXT='%wheel ALL=(ALL) NOPASSWD: /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/zzz, /usr/bin/ZZZ'
    echo "$TEXT" | sudo EDITOR='tee -a' visudo
fi

## AESTHETIC MODIFICATIONS ## ---------------------------------------------- ##

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
sudo install -v s/i3lock-mm /usr/local/bin/;
sudo chmod -v +x /usr/local/bin/i3lock-mm
mkdir -pv $HOME/system/wallpaper/lockscreens/
cp -v s/lockscreen.surf.png $HOME/system/wallpaper/lockscreens/surf.png

sudo chown -R `whoami`:`whoami` $HOME

mkdir -pv $HOME/.config/gtk-3.0/; G3B=$HOME/.config/gtk-3.0/bookmarks
echo "file:///home/`whoami`/libraries libraries"                          > $G3B
echo "file:///home/`whoami`/intimate intimate"                           >> $G3B
echo "file:///home/`whoami`/system system"                               >> $G3B
echo "file:///home/`whoami`/amusant amusant"                             >> $G3B
echo "file:///network/libraries  libraries"                             >> $G3B
echo "file:///network/intimate  intimate"                               >> $G3B
echo "file:///network/system  system"                                   >> $G3B
echo "file:///network/amusant  amusant"                                 >> $G3B
echo "file:///network/settings  settings"                               >> $G3B

echo "done."
