#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

distro-add Debian-9-x86_64  /root/distro/iso/debian-9.4.0-amd64-DVD-1.iso
distro-add Ubuntu-14-x86_64 /root/distro/iso/ubuntu-14.04.5-server-amd64.iso

cobbler-exec profile add --name="Debian-9-x86_64"  --distro="Debian-9-x86_64"
cobbler-exec profile add --name="Ubuntu-14-x86_64" --distro="Ubuntu-14-x86_64"

cobbler-exec system add --name="debian"  --hostname="debian"  --profile="Debian-9-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="25" --virt-ram="4096" --virt-bridge="bridge0"  --netboot-enabled=1
cobbler-exec system add --name="ubuntu"  --hostname="ubuntu"  --profile="Ubuntu-14-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="25" --virt-ram="4096" --virt-bridge="bridge0"  --netboot-enabled=1

cobbler-exec system add --name="debian-xen"  --hostname="debian-xen"  --profile="Debian-9-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="xen" --virt-file-size="25" --virt-ram="4096" --virt-bridge="bridge0"  --netboot-enabled=1
cobbler-exec system add --name="ubuntu-xen"  --hostname="ubuntu-xen"  --profile="Ubuntu-14-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xen" --virt-file-size="25" --virt-ram="4096" --virt-bridge="bridge0"  --netboot-enabled=1
