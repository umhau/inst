#!/bin/bash

# install each package independently; that way a missing package doesn't stall
# the rest, and I can keep one list of tools for void, ubuntu, OpenBSD, etc.

declare -a PK=(\
void-repo-nonfree void-repo-multilib-nonfree void-repo-multilib \  # void repos
linux-firmware linux-firmware-intel linux-firmware-network \    # wifi firmware
xorg-minimal xorg-fonts xinit \                 # X display server dependencies
xfe i3 j4-dmenu-desktop i3lock feh rofi \             # i3 minimum dependencies
sct nano nload curl tmux htop qdirstat gparted xbindkeys gimp nomacs scrot zenity  \
deadbeef vlc x264 ffmpeg youtube-dl qbittorrent xbanish vim \
rsync arandr font-spleen vscode \
sublime-text3 sublime-merge zenmap maim qemu galculator xpdf \
i3status unzip unrar p7zip font-awesome5 cifs-utils gcc \
ntfs-3g nfs-utils  \                                          # NFS dependencies
chromium-browser chromium firefox \           
gdebi \                                           # package installer for ubuntu
hexchat \                     # IRC. Not ssh-able, but familiar and easy to use.
vim vim-gtk \  # I need the gtk version installed so I have the system clipboard
wpa_gui wpa_supplicant wireless_tools                          # wifi management 
FeatherPad featherpad                    # the preferred minimal gui text editor
fuse-sshfs sshfs openssh-server \  # mount the network drive securely \ robustly
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
cantor-backend-python3 cantor-backend-octave cantor-backend-sage cantor-dev \
cantor-backend-maxima  \
)
