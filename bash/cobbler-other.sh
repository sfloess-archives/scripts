#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

distro-add   Debian-9-x86_64  /root/distro/iso/debian-9.4.0-amd64-DVD-1.iso

cobbler-exec system add --name="debian"  --hostname="debian"  --profile="Debian-9-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="25" --virt-ram="4096" --virt-bridge="bridge0"  --netboot-enabled=1
