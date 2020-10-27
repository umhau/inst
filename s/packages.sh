#!/bin/bash

# install each package independently; that way a missing package doesn't stall
# the rest, and I can keep one list of tools for void, ubuntu, OpenBSD, etc.

declare -a PK=(\
void-repo-nonfree void-repo-multilib-nonfree void-repo-multilib \  # void repos
linux-firmware linux-firmware-intel linux-firmware-network \    # wifi firmware
xorg-minimal xorg-fonts xinit \                 # X display server dependencies
xfe i3 j4-dmenu-desktop i3lock feh rofi \             # i3 minimum dependencies
sct nano nload curl tmux htop qdirstat gparted xbindkeys gimp nomacs scrot zenity  \
deadbeef vlc x264 ffmpeg youtube-dl qbittorrent xbanish \
rsync arandr font-spleen vscode \
# sublime-text3 sublime-merge \
zenmap maim qemu galculator xpdf \
i3status unzip unrar p7zip font-awesome5 cifs-utils gcc \
ntfs-3g nfs-utils  \                                          # NFS dependencies
thinkpad-scripts \                                               # helpful tools
chromium-browser chromium firefox \           
gdebi \                                           # package installer for ubuntu
hexchat \                     # IRC. Not ssh-able, but familiar and easy to use.
vim vim-gtk \  # I need the gtk version installed so I have the system clipboard
wpa_gui wpa_supplicant wireless_tools                          # wifi management 
FeatherPad featherpad                    # the preferred minimal gui text editor
fuse-sshfs sshfs openssh-server \  # mount the network drive securely \ robustly
qemu \ # new shiny virtual machine tool
virtualbox-ose virtualbox virtualbox-dkms virtualbox-ext-pack      # virtualbox! 
stterm st \                                    # void and ubuntu name variations
qt5ct lxappearance \                                          # theme management
breeze-snow-cursor-theme faenza-icon-theme breeze-gtk breeze-gtk-theme \ 
Thunar thunar\               # definitely like it better than spacefm or pcmanfm
cups-filters \                           # this allows installing local printers
ImageMagick \                  # needed for the improved lock screen to function
intel-ucode \                               # might help with external monitors?
texlive-bin \    # provides pdfpages, so that the print_efficiently scripts work
lyx lyx-common fonts-lyx \        # lyx (wysiwyg doc + math, easier than latex?)
sagemath sagemath-common sagemath-doc sagemath-jupyter \ # all-in-one math suite
maxima maxima-doc maxima-share maxima-test wxmaxima xmaxima \  # c. algebra sys.
julia julia-common julia-doc libjulia-dev libjulia1 vim-julia \          # julia
cantor cantor-backend-julia cantor-backend-lua \                 # nice math GUI
cantor-backend-octave cantor-backend-sage cantor-dev cantor-backend-maxima \
\
# -- optional, but awesome -- #
atom \
lm-sensors xsensor psensor \ # then: sudo sensors-detect - sensors
hddtemp macchanger apl pandoc mirage inkscape hdparm xbacklight \
alsa-utils pulseaudio deluge deluge-gtk syncthing syncthing-gtk \
extrace autossh file-roller fex upx sc qrencode darkhttpd wgetpaste \
mdbook ipcalc scrot xlunch surf pwgen ncdu sshfs tcc ponysay snooze \
ledger hledger shmux mblaze dstat atop pv an ncdu xpra fatrace dvtm \
dtach mosh jq ministat task timewarrior gcal zutils spacefm conky \
geany autorandr gopass eog alsa-base zbar-tools python-zbar \
\
moc gnome-chess stockfish hplip-gui simple-scan sane-utils \
openssh openssh-server python-qrtools python-qrcode qrencode \
r-base r-base-dev libjpeg62 dpkg-dev evince gnome-screenshot xournal \
rlwrap lib32z1 lib32ncurses5 gcc-multilib tofrodos gnuplot \
cmake build-essential gfortran gfortran-multilib gfortran-doc \
gfortran-7-multilib gfortran-7-doc libgfortran4-dbg libcoarrays-dev \
gcc g++ git python2.7 python3 python-numpy python-scipy python3-venv \
libssl-dev libffi-dev python3-dev gcc-multilib lua5.3 python-pip \
octave gnuplot vlc banshee x264 mplayer libdvd-pkg audio-recorder  \
gimp imagemagick ffmpeg fswebcam streamer webcam moc soundconverter \
texworks-scripting-lua texworks-scripting-python texworks texlive \
texlive-xetex texlive-extra-utils '--install-suggests texstudio' xfe \
texstudio \
curl  gdebi\
libav-tools gparted dpkg-dev fonts-lyx evince gnome-chess \
stockfish rlwrap libreoffice tofrodos lib32ncurses5 xbindkeys \
gnome-screenshot xournal libqt5widgets5 libqt5network5 libqt5svg5 \
pcmanfm ranger thunar zathura okular mupdf xpdf qdirstat lib32z1 \
dkms build-essential linux-headers-generic linux-headers-$(uname -r) \
)
