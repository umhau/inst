#!/bin/bash

# multimonitor lock screen | dependencies: imagemagick i3lock

# generalized installation allows me to activate lockscreen as root, when the 
# computer is put in sleep mode or hibernation.

# script wrapper screenlock.sh allows me to set the screen to turn off while its
# locked.

sudo install -v s/i3lock-mm             /usr/local/bin/i3lock-mm
sudo install -v s/screenlock.sh         /usr/local/bin/screenlock.sh
sudo install -v s/lockscreen.surf.png   /etc/lockscreen.surf.png


