#!/bin/bash
set -v

# based on https://umhau.github.io/offline-package-installation-with-local-apt-repository/
# create an offline repo. the output of this script is a .tar file that can be downloaded and moved to the offline machine.

repository_name="repo-`date +"%Y-%m-%d-%H-%M"`"

pathname="/home/`whoami`/$repository_name" && mkdir -p $pathname

source ./offline_package_list.sh

for PKG in "${PK[@]}"
do
  sudo apt -d install $PKG -y
  sudo cp -n /var/cache/apt/archives/*.deb "$pathname/"
  sudo apt clean
done

sudo apt-get install dpkg-dev -y
cd /home/`whoami`/$repository_name
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

cd ..; tar cfv "$repository_name".tar $pathname
