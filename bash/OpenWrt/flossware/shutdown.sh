#!/bin/bash

umount -a

/etc/init.d/rsync             stop
/etc/init.d/ssh               stop
/etc/init.d/nfs-kernel-server stop
/etc/init.d/rpcbind           stop
/etc/init.d/cron              stop
/etc/init.d/rsyslog           stop

