#!/bin/bash

# put a menu that organizes and lists programs down in the tray
# git clone https://github.com/trizen/menutray.git
sudo install s/menutray/menutray /usr/local/bin/
mkdir -p /home/`whoami`/.config/menutray
sudo install -v s/menutray/schema.pl /home/`whoami`/.config/menutray/