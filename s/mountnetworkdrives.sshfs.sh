# how can this be improved? 
# given the reconnect option, maybe the while loop can be dropped?

FOLDERS=(amusant intimate system libraries settings)
OPTIONS="allow_root,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3"

for F in ${FOLDERS[@]}; do 
    echo "mounting $F"
    sshfs -o "$OPTIONS" personalstorage:/networkstorage/$F /network/$F 
done

# allow_root:   otherwise any command invoking sudo and involving the sshfs 
# directory will fail.

# reconnect,ServerAliveInterval=15,ServerAliveCountMax=3: this is supposed to 
# help the drive respond to a lost connection, and either give an IO error
# (after trying 3 times at 15 second intervals to find the network drive) or
# reconnect to the drive.  It should prevent programs from hanging (like MS
# Code was doing)
# https://serverfault.com/questions/6709/sshfs-mount-that-survives-disconnect
