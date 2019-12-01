#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system remove --name="cloud-host-01"

    cobbler-exec system add --name="cloud-host-01" --hostname="cloud-host-01" --profile="CentOS-7-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --virt-type="xenpv" --ksmeta='lvmDisks="sda sdb" completionMethod=reboot'

    cobbler sync

