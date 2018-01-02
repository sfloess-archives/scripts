#!/bin/sh -x

exec >> /mnt/sda1/debian/var/log/user.log 2>&1
/mnt/sda1/debian/flossware/bootup.sh /flossware/startup.sh
