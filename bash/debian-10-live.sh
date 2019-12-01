#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

distro-add-live  Debian-10-live-x86_64   /opt/iso/debian-10.2.0-amd64-netinst.iso --arch="x86_64" --breed="debian"
#distro-add-live  Debian-10-live-x86_64    /opt/iso/debian-10.0.0-amd64-DVD-1.iso --arch="x86_64" --breed="debian"

exit 1

#cobbler-exec profile add --name="Debian-10-live-x86_64" --distro="Debian-10-live-x86_64" 

#STANDARD_SEED="/var/lib/cobbler/kickstarts/flossware_debian.seed"
STANDARD_SEED="/var/lib/cobbler/kickstarts/generic.seed"

cobbler-exec profile edit --name=Debian-10-live-x86_64 --kickstart=${STANDARD_SEED} --kopts="priority=critical locale=en_US irqpoll debian-installer/allow_unauthenticated=true netcfg/choose_interface=eth0"

cobbler-exec system remove --name="debian-live"
cobbler-exec system add --name="debian-live" --hostname="debian-live" --profile="Debian-10-live-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_SEED}" --virt-auto-boot=0  --kopts="priority=critical locale=en_US irqpoll debian-installer/allow_unauthenticated=true netcfg/choose_interface=eth0"
#cobbler sync

