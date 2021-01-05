#!/bin/bash

# ba.dum.t.sh
# Better At Doing UnMounts Than Some Humans

# requires: lsof

# todo: 
# - turn off hard drives
# - unfreeze network mounts

# goal: get anything removed, without requiring a reboot. Icing: document how it
# was done, so that the methods can be used in the future.

StillMounted=0

mountpoint="$1"

# internal drive? 
# external HDD? 
# external SSD? 
# network NFS drive? 
# network SSHFS drive?

sudo umount "$mountpoint"                                      && StillMounted=1

# The umount command detaches the mentioned filesystem(s) from the file
# hierarchy.  A filesystem is specified by giving the directory where it
# has been mounted.  Giving the special device on which the filesystem
# lives may also work, but is obsolete, mainly because it will fail in
# case this device was mounted on more than one directory.

# Note that a filesystem cannot be unmounted when it is 'busy' - for
# example, when there are open files on it, or when some process has its
# working directory there, or when a swap file on it is in use.  The
# offending process could even be umount itself - it opens libc, and libc
# in its turn may open for example locale files.  A lazy unmount avoids
# this problem, but it may introduce other issues. See --lazy description
# below.

sudo umount -l "$mountpoint"                                   && StillMounted=2

# -l
# A system reboot would be expected in near future if you're going to use this 
# option for network filesystem or local filesystem with submounts.  The 
# recommended use-case for umount -l is to prevent hangs on shutdown due to an 
# unreachable network share where a normal umount will hang due to a downed 
# server or a network partition. Remounts of the share will not be possible.

lsof "$mountpoint"

# lsof - list open files
# An open file may be a regular file, a directory, a block special file,
# a character special file, an executing text reference, a library, a
# stream or a network file (Internet socket, NFS file or UNIX domain
# socket.)  A specific file or all the files in a file system may be
# selected by path.

echo "Please close the files shown above. Close by force without saving?"