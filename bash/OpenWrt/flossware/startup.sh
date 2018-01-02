#!/bin/bash

#chmod 700 /etc/ssh/* /var/run/sshd

/etc/init.d/rsyslog           start
/etc/init.d/cron              start
/etc/init.d/rpcbind           start
/etc/init.d/nfs-kernel-server start
/etc/init.d/ssh               start
/etc/init.d/rsync             start

mount -a
