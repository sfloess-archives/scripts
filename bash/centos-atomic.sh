#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'
CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"

distro-add-atomic CentOS-7-Atomic-x86_64  /opt/distro/iso/CentOS-Atomic-Host-7-Installer.iso --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"

#cobbler-exec profile add --name="CentOS-7-Atomic-x86_64"  --distro="CentOS-7-Atomic-x86_64"  --kickstart="${CENTOS_ATOMIC_KICKSTART}"

#cobbler-exec system add --name="centos-atomic-kvm"  --hostname="centos-atomic-kvm" --profile="CentOS-7-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="centos-atomic"' --kickstart="${CENTOS_ATOMIC_KICKSTART}" --netboot-enabled=1
