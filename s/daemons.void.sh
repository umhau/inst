## DAEMONS INITIALIZATION ## ----------------------------------------------- ##

# also: smbd udevd  dhcpcd cupsd | NFS: nfs-server statd rpcbind
[ ! -d /var/service/sshd ] && sudo ln -sv /etc/sv/sshd /var/service/      # ssh
[ ! -d /var/service/acpid ] && sudo ln -sv /etc/sv/acpid /var/service/ #suspend
[ ! -d /var/service/cupsd ] && sudo ln -sv /etc/sv/cupsd /var/service/  # print
# also ntpd, after the dependency (ntp?) is installed