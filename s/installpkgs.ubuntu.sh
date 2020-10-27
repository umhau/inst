#!/bin/bash

sudo apt --purge autoremove -y
sudo apt update
sudo apt upgrade -y

echo "installing packages: $PK"
for pkg in "${PK[@]}";do sudo apt install -y "$pkg";done

sudo apt --purge autoremove -y
sudo apt update
sudo apt upgrade -y
