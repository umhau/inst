#!/bin/bash

# new structure. One install script; anything that's incompatible gets split into a separate script labeled <function>.<os version>.sh.  If there's three OSes, split it 3 ways. Keeps it simple, with only a little extra bookkeeping. 

#define OS version (very pseudo pseudocode)
case $1
  switch ubuntu
  switch void
  switch openbsd
  else "provide a correct OS version to the script"
 done

#e.g.:
autologin.$osversion.sh

