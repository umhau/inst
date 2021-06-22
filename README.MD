# README

In order to install the autologin script, make sure that you are logged in at
tty2, NOT tty1.  

To perform a full system configuration, run the install script corresponding to your base OS.  

    bash install.void.sh

# TODO

Many of these things are discussed on the void wiki. 
https://wiki.voidlinux.org/Post_Installation

## program configs

 - [ ] VLC preferences: 
    * allow multiple instances
    * increase disk cache to ~10 seconds: helps when playing over remote filesystems

## network

once I have a working VPN pointing back to my home network, there's a lot of things that can be improved and simplified. 

 - [ ] synchronize configurations with the main server, e.g. wifi passwords & SSIDs.

 - [ ] zero or thin clients will be possible: make the network drive the primary storage that gets mounted whenever the network connection goes up. Thus, ~/libraries (etc) are mount points for the network library.

    - local storage could use a system link from e.g. ~/.libraries to ~/libraries, so that there's a fallback when the internet is down.  There might be some software out there that lets me cache anything recently used on the local drive, given the space usage is ok.

### PXEN will allow for generalized zero/thin-clients. 

- There is a system for sharing USB devices over the network; if this is included on all guests, then it might be possible to access any USB from any system. http://usbip.sourceforge.net/

### synchronized files

- ssh / tcp connections list
- wpa_supplicant config with passwords

## installation
- [ ] ensure that I can rerun this tool repeatedly, without damage. this allows 
      me to continuously edit a preexisting OS installation.
- [ ] put most of the information on a second tty.  errors on one, verbosity on 
      another.  1>/dev/tty3, 2>/dev/tty4, etc.
- [ ] install a proper ntp daemon. See: https://wiki.voidlinux.org/NTP
- [ ] run the package installation as root - maybe even the whole thing. solves the timeout issue when tons of stuff gets installed.

## file organization
- [ ] put the inst folder this github repo represents into the ~/system folder.
- [X] automount folders into /network
- [ ] copy files from AS_VX HDDs to NAS
- [X] adjust folders: downloads,screenshots,desktop,documents,pictures -> 'unsorted'
- [ ] make system/scripts/i3/ and put all system management scripts in there.

## interface improvement
- [X] fix themes and appearance (install packages, config, and extract configs)
- [ ] theme rofi
- [ ] build pie menu - arbitrary layers and items per-layer, themeable, built in pure X
- [ ] build shutdown menu, find a way to activate it

## utility improvement
- [ ] script to manage displays - autorandr is unreliable (or does it get confused by multiple matching configurations?)
- [ ] adjust brightness directly with `/sys/class/backlight/*/brightness`
- [ ] modify trackball mice button actions
- [X] date indicator on i3status
- [ ] hostname indicator on i3status
- [ ] meta workspaces: https://github.com/mrconter1/i3_meta_workspaces
- [ ] use a single .bashrc that sources the ubuntu / void variants. I think I did this, just didn't push it. 
- [ ] add aliases: `tmux list-sessions` and `tmux attach-session -t "$session_name"`

## BUGS

- [ ] /network/settings blocks all access when using sudo, which means I can't use `sudo install`.

## installation scripts
general: make it obvious that they work, when I come back to them after a year

## NOTES

modify acpi actions (lid close, power button, etc.) with /etc/acpi/handler.sh

		# install APL keyboard
		mkdir -p ~/.fonts; cp $fd/Apl385.ttf ~/.fonts/; setxkbmap us,apl -option "grp:switch"

# tools for the future

Running headless means no monitor. No xsercer/de/wm means no desktop, gui, it's all command line. Pihole is dns adblocker, pivpn is a VPN. Syncthing is a program to automatically sync files/folders from multiple devices to a storage device. Sonarr, radarr, lidarr are (in order) TV show, movies, and music auto downloading torrent clients. Input what you want to download, what quality, and it'll download it automatically when it comes out, so with sonarr, you put a TV show in, it'll download the newest episode when there's a torrent available. Jackett just adds extra torrent sites to those 3 programs. Organizr is a custom home page app, that let's you have a bunch of self hosted webpages inside one webpage, so you can launch one page and have your pihole admin page, and whatever else you need, on one page, so you don't have to remember the local addresses or manually open each one. Mtproto proxy (for telegram the message app) is just a proxy specifically for telegram, so I connect to the proxy which connects to telegrams servers for me. Like having a VPN specifically just for telegram. Shadowsocks socks5 proxy is like a mini-vpn? Hard to explain, works like a vpn, proxies were more popular back in the day before vpns. Dnscrypt-proxy encrypts all your dns traffic. Kodi is a media player like Plex. You can stream TV, movies, etc from Kodi to your TV or other devices, like a custom Roku. Nginx is a web server, MySQL is a database server, php/nodejs/python are programming languages. Tor socks proxy just allows me to use to/onion ("dark web"). Zeronet is a decentralized internet, you host a website on your computer, you and whoever visits it, serves the content to new visitors. Your site can't be censored, same with other sites as long as one person still had it. i2p is an anonymous browsing service like Tor. Have any questions just ask. If you need help, just ask.
https://boards.4channel.org/g/thread/73118797#p73126664

# system configuration

installed
(
    [*] indicates keep,
    [-] indicates do not preserve
    [x] install if not present
):

[*] texlive
[*] powertop
[*] epson-inkjet-printer-escpr
[*] void-repo-nonfree
[*] virtualbox-ose
[-] virtualbox-ose-guest
[*] wpa_gui
[*] rsync
[x] arandr
[x] texlive texstudio
[x] surf
[*] sublime-text3
[*] sublime-merge
[-] thinkpad-scripts
[-] tp_smapi-dkms
[-] tpacpi-bat
[*] surf

config commands:

    after installing texlive
    sudo ln -s /opt/texlive/2018/bin/x86_64-linux/pdflatex /usr/local/bin/pdflatex
    sudo tlmgr install multirow
    the above installs latex packages via commandline

    created link that starts sshd
    sudo ln -s /etc/sv/sshd /var/service/

    installed powertop, ran all configurations. not sure if battery life improved.

    installed void-repo-nonfree
    nonfree repo package fixed the missing packages (i.e. sublime) issue

    sudo usermod -a -G vboxusers `whoami`
    enable virtualbox features like USB; don't install guest packages
    # do these to get vbox working as host
    sudo xbps-reconfigure -f virtualbox-ose-dkms
    sudo modules-load

    initialize acpi daemon to get suspend working.
    sudo ln -s /etc/sv/acpid /var/service/
    (use /etc/acpi/handler.sh to mess around with what happens when the lid is
    closed, etc.) after that is done, the command acpi_listen works.

    echo 1 > /sys/class/leds/tpacpi\:\:kbd_backlight/brightness
    can successfully modify the keyboard backlight of the x230

X   GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_osi=" >> /etc/default/grub
X   sudo update-grub
X   these should enable acpi events, including detecting the lid close event.                

problems:

X   ethernet is not automatically activated. I think that's a difference in the
X   wpa_supplicant default .conf script, compared the custom one I used.
X   enabling the acpi daemon (above) solved this.

    simple way to recover the aesthetic changes. also I didn't save the config I
    used...but it might still be in the home folder settings I saved.

X   lid close is not detected. there are some thinkpad oriented packages that
X   could solve the problem after a reboot.

    tmux does not save commands into .bash_history. find a way to fix that.

    it's possible to show volume in i3bar, but it slows the computer system
    considerably.  lots of disk access.  instead, write volume to text file
    whenever it's changed, and read that?

    similar problem, it doesn't adjust immediately.  there's a delay.

    using the external monitor, starting an application, and removing the
    monitor seems to cause the bad scaling of programs.
    https://www.reddit.com/r/i3wm/comments/7ghggd/properly_configuring_dpi_and_scaling_when_using_i3/


other general TODO items:

    configure themes, using these tools.
    https://askubuntu.com/questions/598943/how-to-de-uglify-i3-wm

    Add this to your .tmux.conf
    set -g history-file ~/.tmux_history

# long term project: Plan 9

Critical tools:
- [ ] i3: call it i9
- [ ] web browser (surf?)
- [ ] qemu
- [ ] GUI text editor / emacs / vim
- [ ] file browser
