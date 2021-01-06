#!/bin/bash

# KISS for IRC, a tiny IRC client written in POSIX C99.
# https://github.com/mcpcpc/kirc


# -- installation --------------------------------------------------------------

mkdir -pv ~/system/software && cd ~/system/software/

git clone https://github.com/mcpcpc/kirc.git
cd kirc
make
sudo make install

