#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../scripts/bash/cobbler-utils.sh

remove-all

ENTERPISE_KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com packages=koan,redhat-lsb"
distro-add-atomic CentOS-7.1-Atomic-x86_64 /root/distro/iso/CentOS-Atomic-Host-7-Installer.iso      --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"

CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/centos-atomic.ks"
cobbler-exec profile add  --name="CentOS-7.1-Atomic-x86_64" --distro="CentOS-7.1-Atomic-x86_64" --kickstart="${CENTOS_ATOMIC_KICKSTART}"
cobbler-exec system add --name="centos-atomic-master" --hostname="centos-atomic-master" --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"