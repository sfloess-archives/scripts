#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

#distro-add  Ubuntu-19-x86_64   /opt/iso/ubuntu-19.10-server-amd64.iso      --breed ubuntu

#cobbler-exec profile add --name="Ubuntu-19-x86_64" --distro="Ubuntu-19-x86_64" 

#STANDARD_SEED="/var/lib/cobbler/kickstarts/flossware_debian.seed"
DISTRO_NAME="Ubuntu-19-x86_64"
STANDARD_SEED="/var/lib/cobbler/kickstarts/generic.seed"

cobbler-exec distro edit --name="${DISTRO_NAME}" --ksmeta="tree=http://192.168.168.32/cblr/links/${DISTRO_NAME}" --kopts="priority=critical locale=en_US"
cobbler-exec profile edit --name=Ubuntu-19-x86_64 --kickstart=${STANDARD_SEED} --kopts="priority=critical locale=en_US"

cobbler-exec system remove --name="ubuntu-test"
cobbler-exec system add --name="ubuntu-test" --hostname="ubuntu-test" --profile="Ubuntu-19-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_SEED}" --virt-auto-boot=0  --kopts="priority=critical locale=en_US"
#cobbler sync

