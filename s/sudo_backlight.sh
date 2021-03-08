#!/bin/bash

# control the backlight
if ! grep --quiet "/sys/class/backlight" /etc/sudoers 2>/dev/null; then
    TEXT='%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/backlight/*/brightness'
    echo "$TEXT" | sudo EDITOR='tee -a' visudo
fi