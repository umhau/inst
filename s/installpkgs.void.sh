#!/bin/bash

echo "installing packages. see tty8 for details. failed packages are skipped."

source s/packages.sh

# make sure xbps is updated
sudo xbps-install -Su xbps; sudo xbps-install -Su xbps

# install each package separately to avoid an error killing the whole process
for package in "${PK[@]}" ; do 

    echo "Installing package: $package"
    
    sudo xbps-install -y "$package" # | sudo tee -a /dev/tty8; 

done
