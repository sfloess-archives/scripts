#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

cobbler-exec system remove --name="host-2"
cobbler-exec system add --name="host-2" --hostname="host-2" --profile="Fedora-27-x86_64"   --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc"' --kickstart="${STANDARD_KICKSTART}" --ksmeta="packages='python,libselinux-python,koan,urlgrabber'"
