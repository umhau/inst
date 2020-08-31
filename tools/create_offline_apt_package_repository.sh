#!/bin/bash
set -ev

# based on https://umhau.github.io/offline-package-installation-with-local-apt-repository/
# create an offline repo. the output of this script is a .tar file that can be downloaded and moved to the offline machine.

pkgs=(banshee vlc emacs )
fnm="/home/`whoami`/myrepository && mkdir $fnm
for PKG in "${pkgs[@]}"; do sudo apt -d install $PKG -y; sudo cp -n /var/cache/apt/archives/*.deb "$fnm/"; sudo apt clean; done

sudo apt-get install dpkg-dev
cd /home/`whoami`/myrepository
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
sudo update-mydebs

cd; tar cfv "$fnm".tar $fnm
