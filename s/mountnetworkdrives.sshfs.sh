# how can this be improved? 
# given the reconnect option, maybe the while loop can be dropped?

i=0
while (($i<40));do 

if ! mount | grep personalstorage; then
if [[ `iwgetid -r` =~ "UXB2O" ]]; then
ssh-add ~/.ssh/sshfs.key ``
sshfs -o allow_root,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 personalstorage:/networkstorage/amusant   /network/amusant
sshfs -o allow_root,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 personalstorage:/networkstorage/intimate  /network/intimate 
sshfs -o allow_root,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 personalstorage:/networkstorage/system    /network/system 
sshfs -o allow_root,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 personalstorage:/networkstorage/libraries /network/libraries 
sshfs -o allow_root,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 personalstorage:/networkstorage/settings  /network/settings 



fi; fi; ((i++)); sleep 5; done 

# allow_root:   otherwise any command invoking sudo and involving the sshfs 
# directory will fail.

# reconnect,ServerAliveInterval=15,ServerAliveCountMax=3: this is supposed to 
# help the drive respond to a lost connection, and either give an IO error
# (after trying 3 times at 15 second intervals to find the network drive) or
# reconnect to the drive.  It should prevent programs from hanging (like MS
# Code was doing)
# https://serverfault.com/questions/6709/sshfs-mount-that-survives-disconnect