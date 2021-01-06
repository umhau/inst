#!/bin/bash

# install each package independently; that way a missing package doesn't stall
# the rest, and I can keep one list of tools for void, ubuntu, OpenBSD, etc.

declare -a PK=( 

void-repo-nonfree void-repo-multilib-nonfree void-repo-multilib     # void repos
xorg-minimal xorg-fonts xinit i3                         # i3 & X display server
i3lock                                                              # lockscreen
feh                                                             # set background
i3status                                                            # status bar
j4-dmenu-desktop rofi xlunch                                     # app launchers

xset                                           # prevent screen from turning off
font-awesome5                                          # symbolic font for icons
qt5ct lxappearance                                            # theme management
breeze-snow-cursor-theme faenza-icon-theme breeze-gtk breeze-gtk-theme   # theme
ImageMagick                    # needed for the improved lock screen to function

stterm st tmux                                    # preferred terminal emulators

sct                                                # change color temp of screen
xbindkeys xev                                     # keyboard and mouse shortcuts
xbacklight                                                    # adjust backlight

evince xpdf eog                                                     # pdf viewer
deadbeef moc vlc x264 ffmpeg soundconverter mplayer libdvd-pkg   # music & video
fswebcam                                                                # webcam
mirage nomacs                                                    # image viewers
libreoffice                                                        # office docs
inkscape gimp                                                 # graphics editors
ledger hledger                                                      # accounting

alsa-base alsamixer alsa-utils pulseaudio                     # sound management

htop nload iotop dstat atop ncdu pv                            # system monitors
zenity                                                   # display popup dialogs
xbanish                                          # hide mouse cursor when typing
flameshot scrot maim                                          # screenshot tools
arandr autorandr                                  # monitor / display management
galculator                                                    # popup calculator

linux-firmware linux-firmware-intel linux-firmware-network       # wifi firmware
wpa_gui wpa_supplicant wireless_tools                          # wifi management
zenmap macchanger ipcalc                                      # networking tools

deluge deluge-gtk                                                   # bittorrent
youtube-dl                                         # download videos from online
chromium-browser chromium firefox surf                       # internet browsers

Thunar thunar                # definitely like it better than spacefm or pcmanfm
xfe                                                      # minimal file explorer
unzip unrar p7zip cifs-utils file-roller gzip tar               # file archiving

openssh openssh-server autossh shmux                                       # ssh
mosh             # Mobile shell, remote terminal application that allows roaming

syncthing syncthing-gtk                                   # file synchronization

rsync curl wget                                                   # file pushers
ntfs-3g nfs-utils                                             # NFS dependencies
fuse-sshfs sshfs                                          # mount network drives
gparted                                                      # manage partitions
qdirstat                                                    # analyse disk usage

gdebi                                             # package installer for ubuntu

qemu                                            # new shiny virtual machine tool
virtualbox-ose virtualbox virtualbox-dkms virtualbox-ext-pack      # virtualbox!

hplip-gui                                                # HP printer management
cups-filters                             # this allows installing local printers
brother-brlaser                                    # driver for my laser printer
simple-scan sane-utils sane                                      # scanner tools

intel-ucode                                 # might help with external monitors?
texlive-bin      # provides pdfpages, so that the print_efficiently scripts work

nano                                                         # basic text editor
vim vim-gtk    # I need the gtk version installed so I have the system clipboard
vscode                                                             # awesome IDE
geany      # the preferred minimal gui text editor. Customizable & decently fast
git gitk git-gui                         # extremely useful git management tools
font-spleen                                          # nice font for development

lyx lyx-common fonts-lyx          # lyx (wysiwyg doc + math, easier than latex?)
pandoc                                              # document format conversion

biber                                                 # for latex bibliographies
texworks-scripting-lua texworks-scripting-python texworks             # texworks
texlive texlive-xetex texlive-extra-utils texlive-latexextra texlive-PythonTeX
'--install-suggests texstudio'  texstudio                            # texstudio

sagemath sagemath-common sagemath-doc sagemath-jupyter   # all-in-one math suite
maxima maxima-doc maxima-share maxima-test wxmaxima xmaxima    # c. algebra sys.
julia julia-common julia-doc libjulia-dev libjulia1 vim-julia            # julia
octave gnuplot                                                    # MATLAB clone

cantor cantor-backend-julia cantor-backend-lua                   # nice math GUI
cantor-backend-octave cantor-backend-sage cantor-dev cantor-backend-maxima

ministat                                              # small statistics utility

cmake build-essential gfortran gfortran-multilib gfortran-doc           #FORTRAN
gfortran-7-multilib gfortran-7-doc libgfortran4-dbg libcoarrays-dev

gcc g++ musl tcc gcc-multilib                                                # C
python2.7 python3 python-numpy python-scipy python3-venv                # python
apl                                                     # a programming language
clisp                                                                     # lisp
r-base r-base-dev                                                            # R

extrace gdb fatrace rlwrap                                           # debugging

dkms linux-headers linux-headers-generic linux-headers-$(uname -r) # kernel bits

lm-sensors xsensor psensor thinkpad-scripts hddtemp          # laptop management then: sudo sensors-detect - sensors
hdparm                                                         # disk management

python-qrtools python-qrcode qrencode zbar-tools python-zbar    # QR & bar codes

dpkg-dev build-essential                        # build ubuntu / debian packages 
 
snooze  
zutils   
xournal

# libjpeg62  
lib32z1 lib32ncurses5    
libssl-dev libffi-dev python3-dev gcc-multilib lua5.3 python-pip  
libav-tools
tofrodos 
# lib32ncurses5   
# libqt5widgets5 libqt5network5 libqt5svg5  
# lib32z1

)

# gnome-chess stockfish                                                  # chess
# an                                                         # anagram generator

# FeatherPad featherpad                         # previous preferred text editor
# hexchat                      # IRC. Not ssh-able, but familiar and easy to use
# qbittorrent              # previous bittorrent client; deluge is more flexible
# sublime-merge      # previously used for git interactions. inferior to git gui
# sublime-text3       # previously preferred text editor. Has memory leaks. Nag.
# gnome-screenshot                      # screenshot tool; too many dependencies

# xpra             # Persistent remote display server and client for X11 clients
# dvtm                                   # Tiling window manager for the console


# conky                                     # display system info on the desktop

# mblaze                                              # command line mail client
# fex                                          # Flexible field/token extraction
# darkhttpd                                                          # webserver
# banshee                                                         # music player
# audio-recorder                                               # sound recording
# pcmanfm ranger                                                 # file managers

# sc                                                  # curses-based spreadsheet
# zathura okular mupdf                                       # other pdf viewers
# wgetpaste     # Script that automates pasting to a number of pastebin services
# mdbook                                       # Create book from markdown files
# upx                                          # Ultimate Packer for eXecutables
# dtach                              # emulates the detach feature of GNU screen
# jq                                               # command line json processor
# task timewarrior gcal                 # command line time management utilities
# pwgen gopass                                                       # passwords
