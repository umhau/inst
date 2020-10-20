# this is for the autologin, since I'm altering the behavior of tty1.
if tty | grep -q 'tty1'; then echo "use tty2!"; exit; fi

# automatic login | you MUST be logged in at tty2, NOT tty1, when this is run
# https://wiki.voidlinux.org/Automatic_Login_to_Graphical_Environment
if [ -d /var/service/agetty-tty1 ]; then
    sudo cp -Rv /etc/sv/agetty-tty1 /etc/sv/agetty-autologin-tty1
    CONF='/etc/sv/agetty-autologin-tty1/conf'
    echo "GETTY_ARGS=\"--autologin `whoami` --noclear\""     | sudo tee    $CONF
    echo "BAUD_RATE=38400"                                   | sudo tee -a $CONF
    echo "TERM_NAME=linux"                                   | sudo tee -a $CONF
    sudo rm -v /var/service/agetty-tty1
    sudo ln -sv /etc/sv/agetty-autologin-tty1 /var/service
fi

