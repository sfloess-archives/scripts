#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

cobbler-exec system remove --name="host-1"
#cobbler-exec system add    --name="host-1" --hostname="host-1" --profile="Fedora-27-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --virt-type="xenpv" --ksmeta='lvmDisks="sda sdb"'
cobbler-exec system add    --name="host-1" --hostname="host-1" --profile="Fedora-27-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --virt-type="xenpv" --ksmeta='lvmDisks="sda sdb" packages=""' --kickstart="${STANDARD_KICKSTART}"
