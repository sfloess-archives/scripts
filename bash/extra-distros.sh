#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

#distro-add  Ubuntu-19-x86_64   /opt/iso/ubuntu-19.10-server-amd64.iso      --breed ubuntu
#distro-add  Debian-10-x86_64   /opt/iso/debian-10.0.0-amd64-DVD-1.iso
#distro-add  windows-10-x86_64  /opt/iso/Windows_10_English_1803_x86-64.iso --breed windows

#cobbler-exec profile add --name="Debian-10-x86_64" --distro="Debian-10-x86_64" 

STANDARD_SEED="/var/lib/cobbler/kickstarts/flossware.seed"

cobbler-exec system add --name="debian-test" --hostname="debian-test" --profile="Debian-10-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_SEED}" --virt-auto-boot=0
#cobbler sync

