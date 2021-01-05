## MOUNT NETWORK DRIVES ## ------------------------------------------------- ##

set -e

# if the NAS is still in use, this should allow access. Remember to keep the
# folder hierarchy in sync accross files.

# TODO: use custom ssh key for the sshfs connection.

NAShostname="personalstorage"
keyname="personalstorage.sshfs.key"

mkdir -pv $HOME/.ssh; CONFIG=$HOME/.ssh/config
echo "Host $NAShostname"                                              > $CONFIG
echo "HostName $NAShostname"             >> $CONFIG # alternately an IP address
echo "User `whoami`"                                                 >> $CONFIG

# set up passwordless ssh, so that I can use sshfs to access storage server
if [ ! -f $HOME/.ssh/id_rsa ];then
# if [ ! -f $HOME/.ssh/sshfs.key ];then
    # ssh-keygen -f $HOME/.ssh/sshfs.key
    # ssh-copy-id -i $HOME/.ssh/sshfs.key.pub `whoami`@$NAShostname
    # the above method works, except that I would have to specify a nonstandard
    # key every time I wanted to login.  Maybe that's fine for the sshfs, but I
    # need to use a better keyname, AND I need to actually use it in the mount
	# script.
    ssh-keygen 
    ssh-copy-id `whoami`@$NAShostname
fi

[ ! -f /etc/fuse.conf.bak ] && sudo cp /etc/fuse.conf /etc/fuse.conf.bak
echo "user_allow_other" | sudo tee /etc/fuse.conf # required for allow_root


