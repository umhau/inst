#!/bin/bash

# multimonitor lock screen | dependencies: imagemagick i3lock
sudo install -v s/i3lock-mm /usr/local/bin/;
sudo chmod -v +x /usr/local/bin/i3lock-mm
mkdir -pv $HOME/system/wallpaper/lockscreens/
cp -v s/lockscreen.surf.png $HOME/system/wallpaper/lockscreens/surf.png

