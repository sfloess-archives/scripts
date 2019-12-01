#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

cobbler-exec system remove --name="elk"
cobbler-exec system add --name="elk" --hostname="elk"  --profile="CentOS-7-x86_64"  --interface="eth0" --mac-address="00:16:3e:6b:17:3d" --virt-type="xenpv" --virt-file-size="50"  --virt-ram="3500" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="completionMethod=poweroff" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0 

cobbler sync