# remote network drive mounts

This is complicated, and this is the third attempt to get it right. I'm using
SSHFS because it seems much more robust than NFS, and less likely to freeze my
system.

There's some options that have to be set. Below are notes on the options I've 
considered so far. 

    allow_root:   otherwise any command invoking sudo and involving the sshfs 
    directory will fail.  This requires an option to be set in /etc/fuse.conf:
    user_allow_other.

    reconnect,ServerAliveInterval=15,ServerAliveCountMax=3: this is supposed to 
    help the drive respond to a lost connection, and either give an IO error
    (after trying 3 times at 15 second intervals to find the network drive) or
    reconnect to the drive.  It should prevent programs from hanging (like MS
    Code was doing)
    https://serverfault.com/questions/6709/sshfs-mount-that-survives-disconnect

