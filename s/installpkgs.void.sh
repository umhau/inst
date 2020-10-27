#!/bin/bash

source s/packages.sh

# make sure xbps is updated
sudo xbps-install -Su xbps; sudo xbps-install -Su xbps

# install each package separately to avoid an error killing the whole process
for p in "${PK[@]}"; do sudo xbps-install -y "$p"; done
