#!/bin/sh

debdir=/mnt/sda1/centos

mkdir -p $debdir/proc $debdir/sys $debdir/dev $debdir/dev/pts $debdir/tmp

cat /etc/mtab > $debdir/etc/fstab

mount -t devpts none  $debdir/dev/pts

mount -o bind   /proc $debdir/proc
mount -o bind   /sys  $debdir/sys
mount -o bind   /dev  $debdir/dev
mount -o bind   /tmp  $debdir/tmp

#mount -o bin    /etc/debian_ssh         $debdir/etc/ssh

/bin/busybox chroot $debdir /bin/bash

umount $debdir/tmp
umount $debdir/dev
umount $debdir/sys
umount $debdir/proc

umount $debdir/dev/pts

exit $?

