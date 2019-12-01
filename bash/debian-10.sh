#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

#distro-add  Debian-10-x86_64   /opt/iso/debian-10.0.0-amd64-DVD-1.iso

#cobbler-exec profile add --name="Debian-10-x86_64" --distro="Debian-10-x86_64" 

#STANDARD_SEED="/var/lib/cobbler/kickstarts/flossware_debian.seed"
STANDARD_SEED="/var/lib/cobbler/kickstarts/generic.seed"

cobbler-exec profile edit --name=Debian-10-x86_64 --kickstart=${STANDARD_SEED} --kopts="priority=critical locale=en_US irqpoll debian-installer/allow_unauthenticated=true netcfg/choose_interface=eth0"

cobbler-exec system remove --name="debian-test"
cobbler-exec system add --name="debian-test" --hostname="debian-test" --profile="Debian-10-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_SEED}" --virt-auto-boot=0  --kopts="priority=critical locale=en_US irqpoll debian-installer/allow_unauthenticated=true netcfg/choose_interface=eth0"
#cobbler sync

