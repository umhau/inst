
# automatic login 
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo rm -rf /etc/systemd/system/getty@tty1.service.d/override.conf

WRT() { echo "$1" | sudo tee -a /etc/systemd/system/getty@tty1.service.d/override.conf; }

WRT '[Service]'
WRT 'ExecStart='
WRT "ExecStart=-/sbin/agetty --noissue --autologin `whoami` %I \$TERM"
WRT 'Type=idle'