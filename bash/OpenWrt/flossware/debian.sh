#!/bin/sh /etc/rc.common

START=99
STOP=1

start() {
	/etc/init.d/debian-pause.sh &
}

stop() {
	/mnt/sda/debian/flossware/bootdown.sh
}

