#!/bin/bash

# reboot without root password 
if ! sudo grep --quiet "/usr/bin/reboot" /etc/sudoers 2>/dev/null; then
    TEXT="`whoami` ALL = NOPASSWD: /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/zzz, /usr/bin/ZZZ"
    echo "$TEXT" | sudo EDITOR='tee -a' visudo
fi