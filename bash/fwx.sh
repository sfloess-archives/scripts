#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"
    cobbler-exec system add --name="fedora-workstation-xen" --hostname="fedora-workstation-xen"  --profile="Fedora-29-x86_64"  --interface="eth0" --mac-address="00:16:3e:4f:0c:d1" --virt-type="xenpv" --virt-file-size="50"  --virt-ram="3400" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1
