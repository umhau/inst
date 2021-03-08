#!/bin/bash

echo "installing packages. see tty8 for details. failed packages are skipped."

source s/packages.sh

sudo apt --purge autoremove -y
sudo apt update
sudo apt upgrade -y

for package in "${PK[@]}" ; do 
    echo "Installing package: $package"
    sudo apt-get install -y "$package" > /dev/tty8;
done

sudo apt --purge autoremove -y
sudo apt update
sudo apt upgrade -y
