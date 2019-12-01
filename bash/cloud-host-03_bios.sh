#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh


    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="cloud-host-03" --hostname="cloud-host-03" --profile="CentOS-7-i386"   --interface="eth0" --mac-address="00:21:9B:32:5F:78" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc" completionMethod=reboot' 
