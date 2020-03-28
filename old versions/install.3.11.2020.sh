#!/bin/bash

# you MUST be logged in at tty2, NOT tty1, when this is run
# stop the script with ctrl-z

## VARIABLES ## ------------------------------------------------------------ ##

NAShostname="personalstorage"
# IFDIR() {}
# IFFILE() {}
# IFLINE() { if ! grep --quiet "/usr/bin/reboot" /etc/sudoers }

## PACKAGE INSTALL ## ------------------------------------------------------ ##

sudo xbps-install -Su; sudo xbps-install -Su
sudo xbps-install -S void-repo-nonfree void-repo-multilib-nonfree void-repo-multilib 

PK="$PK linux-firmware linux-firmware-intel linux-firmware-network qt5ct sshfs"
PK="$PK xorg-minimal xorg-fonts lxappearance faenza-icon-theme breeze-gtk"
PK="$PK xfe xinit st tmux htop curl nano nload i3 j4-dmenu-desktop i3lock feh"
PK="$PK sct qdirstat gparted firefox xbindkeys gimp nomacs scrot zenity "
PK="$PK deadbeef vlc x264 ffmpeg youtube-dl qbittorrent rofi xbanish vim"
PK="$PK wpa_gui wpa_supplicant rsync virtualbox-ose arandr font-spleen vscode"
PK="$PK sublime-text3 sublime-merge zenmap maim qemu galculator chromium xpdf"
PK="$PK FeatherPad i3status unzip unrar p7zip font-awesome5 cifs-utils "
PK="$PK ntfs-3g wireless_tools imagemagick nfs-utils breeze-snow-cursor-theme"

# PK="$PK atom" # install apl plugin https://github.com/Alhadis/language-apl
# PK="$PK lm-sensors xsensor psensor" # then: sudo sensors-detect -> 'sensors'
# PK="$PK hddtemp macchanger apl pandoc mirage inkscape hdparm xbacklight "
# PK="$PK alsa-utils pulseaudio deluge deluge-gtk syncthing syncthing-gtk"
# PK="$PK extrace autossh file-roller fex upx sc qrencode darkhttpd wgetpaste"
# PK="$PK mdbook ipcalc scrot xlunch surf pwgen ncdu sshfs tcc ponysay snooze"
# PK="$PK ledger hledger shmux mblaze dstat atop pv an ncdu xpra fatrace dvtm "
# PK="$PK dtach mosh jq ministat task timewarrior gcal zutils spacefm conky "
# PK="$PK geany autorandr gopass eog alsa-base zbar-tools python-zbar "

# PK="$PK moc gnome-chess stockfish hplip-gui simple-scan sane-utils "
# PK="$PK openssh openssh-server python-qrtools python-qrcode qrencode"
# PK="$PK r-base r-base-dev libjpeg62 dpkg-dev evince gnome-screenshot xournal"
# PK="$PK rlwrap lib32z1 lib32ncurses5 gcc-multilib tofrodos gnuplot "
# PK="$PK cmake build-essential gfortran gfortran-multilib gfortran-doc"
# PK="$PK gfortran-7-multilib gfortran-7-doc libgfortran4-dbg libcoarrays-dev"
# PK="$PK gcc g++ git python2.7 python3 python-numpy python-scipy python3-venv"
# PK="$PK libssl-dev libffi-dev python3-dev gcc-multilib lua5.3 python-pip "
# PK="$PK octave gnuplot vlc banshee x264 mplayer libdvd-pkg audio-recorder  "
# PK="$PK gimp imagemagick ffmpeg fswebcam streamer webcam moc soundconverter"
# PK="$PK texworks-scripting-lua texworks-scripting-python texworks texlive "
# PK="$PK texlive-xetex texlive-extra-utils '--install-suggests texstudio' xfe"
# PK="$PK skypeforlinux curl firefox gdebi virtualbox syncthing solaar"
# PK="$PK libav-tools gparted xinit dpkg-dev fonts-lyx evince gnome-chess"
# PK="$PK stockfish rlwrap libreoffice tofrodos lib32ncurses5 xbindkeys"
# PK="$PK gnome-screenshot xournal libqt5widgets5 libqt5network5 libqt5svg5 "
# PK="$PK pcmanfm ranger thunar zathura okular mupdf xpdf qdirstat lib32z1"
# PK="$PK dkms build-essential linux-headers-generic linux-headers-$(uname -r)"

sudo xbps-install -Sy $PK

# reconfigure virtualbox here

sudo usermod -aG kvm `whoami`; sudo modprobe -v kvm-intel # qemu adjustments

## FOLDER STRUCTURE ## ----------------------------------------------------- ##
# update xdg directories when these change

mkdir -vp $HOME/system
mkdir -vp $HOME/system/unsorted
mkdir -vp $HOME/system/software
mkdir -vp $HOME/system/wallpaper
mkdir -vp $HOME/system/virtualmachines
mkdir -vp $HOME/system/public
mkdir -vp $HOME/system/templates
mkdir -vp $HOME/system/scripts
mkdir -vp $HOME/system/disk_images

mkdir -vp $HOME/libraries/

mkdir -vp $HOME/amusant/
mkdir -vp $HOME/amusant/images
mkdir -vp $HOME/amusant/music
mkdir -vp $HOME/amusant/videos
mkdir -vp $HOME/amusant/stories
mkdir -vp $HOME/amusant/games

mkdir -vp $HOME/intimate/

sudo mkdir -vp /network/
sudo mkdir -vp /network/amusant
sudo mkdir -vp /network/intimate
sudo mkdir -vp /network/system
sudo mkdir -vp /network/libraries
sudo mkdir -vp /network/settings
sudo chown -Rv `whoami`:`whoami` /network/; sudo chmod -Rv 755 /network/

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

# SCRIPT=$HOME/.mountnetworkdrives.sshfs.sh
# echo "i=0;while ((\$i<4));do if ! mount | grep $NAShostname; then"    > $SCRIPT
# echo 'if [[ `iwgetid -r` =~ "UXB2O" ]]; then '                       >> $SCRIPT
# echo "ssh-add ~/.ssh/sshfs.key"                                      >> $SCRIPT
# echo "sshfs -o allow_root $NAShostname:/srv/sshfs/amusant   /network/amusant"      >> $SCRIPT
# echo "sshfs -o allow_root $NAShostname:/srv/sshfs/intimate  /network/intimate"     >> $SCRIPT
# echo "sshfs -o allow_root $NAShostname:/srv/sshfs/system    /network/system"       >> $SCRIPT
# echo "sshfs -o allow_root $NAShostname:/srv/sshfs/libraries /network/libraries"    >> $SCRIPT
# echo "sshfs -o allow_root $NAShostname:/srv/sshfs/settings  /network/settings"     >> $SCRIPT
# echo "fi; fi; ((i++)); sleep 60; done"                               >> $SCRIPT
# sudo chmod -v +x $HOME/.mountnetworkdrives.sshfs.sh

CONFIG=$HOME/.ssh/config
echo "Host $NAShostname"                                              > $CONFIG
echo "HostName $NAShostname"             >> $CONFIG # alternately an IP address
echo "User `whoami`"                                                 >> $CONFIG

## SYSTEM CONSTRUCTION ## -------------------------------------------------- ##

INSTALL()   { sudo install -Dv "$1" "$2"; sudo chown -v `whoami`:`whoami` $2; }
INSTALL s/nanorc                                                "$HOME/.nanorc"
INSTALL s/bashrc                                                "$HOME/.bashrc"
sudo install -Dv s/XDG-directories                "/etc/xdg/user-dirs.defaults"
INSTALL s/XDG-directories                    "$HOME/.config/user-dirs.defaults"
sudo install -Dv s/rc.local                                     "/etc/rc.local"
INSTALL  s/xinitrc                                             "$HOME/.xinitrc"
[ -d s/fonts ] && cp -v s/fonts/*                               "$HOME/.fonts/"
INSTALL  s/bash_profile                                   "$HOME/.bash_profile"
INSTALL  s/i3config                                   "$HOME/.config/i3/config"
INSTALL  s/i3status.conf                                 "$HOME/.i3status.conf"
sudo install -Dv s/acpi_handler.sh                       "/etc/acpi/handler.sh"
sudo install -Dv s/display_configuration.sh               "/usr/local/bin/disp"
sudo install -Dv s/mountnetworkdrives.sshfs.sh                "/usr/local/bin/"

if [ -f s/wpa_supplicant.conf ];then 
    sudo install -Dv s/wpa_supplicant.conf "/etc/wpa_supplicant/"; fi

# automatic login | you MUST be logged in at tty2, NOT tty1, when this is run
# https://wiki.voidlinux.org/Automatic_Login_to_Graphical_Environment
if [ -d /var/service/agetty-tty1 ]; then
    sudo cp -Rv /etc/sv/agetty-tty1 /etc/sv/agetty-autologin-tty1
    CONF='/etc/sv/agetty-autologin-tty1/conf'
    echo "GETTY_ARGS=\"--autologin `whoami` --noclear\""    | sudo tee    $CONF
    echo "BAUD_RATE=38400"                                  | sudo tee -a $CONF
    echo "TERM_NAME=linux"                                  | sudo tee -a $CONF

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
sudo install -Dv s/vlcrc                                   "$HOME/.config/vlc/"
sudo install -Dv s/wallpaper.sh   "$HOME/system/wallpaper/wallpaper_changer.sh"

# if the network drive providing the wallpaper source is available, use it
if mount | grep "/network/system" > /dev/null; then 
    cp -vr /network/system/wallpaper/current $HOME/system/wallpaper/; fi

# multimonitor lock screen | dependencies: imagemagick i3lock
sudo install -v s/i3lock-mm /usr/local/bin/;
sudo chmod -v +x /usr/local/bin/i3lock-mm

G3B=$HOME/.config/gtk-3.0/bookmarks
echo "file:///home/`whoami`/libraries libraries"                         > $G3B
echo "file:///home/`whoami`/intimate intimate"                          >> $G3B
echo "file:///home/`whoami`/system system"                              >> $G3B
echo "file:///home/`whoami`/amusant amusant"                            >> $G3B
echo "file:///network/libraries  libraries"                            >> $G3B
echo "file:///network/intimate  intimate"                              >> $G3B
echo "file:///network/system  system"                                  >> $G3B
echo "file:///network/amusant  amusant"                                >> $G3B
echo "file:///network/settings  settings"                              >> $G3B

echo "done."