#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system remove --name="rhel-8-kvm"
    cobbler-exec system add --name="rhel-8-kvm" --hostname="rhel-8-kvm" --profile="RHEL-8-x86_64" --interface="eth0"  --mac-address="00:16:3e:5b:1b:52" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=0 --ksmeta="packages='python3,libselinux-python3'" --virt-auto-boot=0

    cobbler-exec system remove --name="rhel-8-xen"
    cobbler-exec system add --name="rhel-8-xen" --hostname="rhel-8-xen" --profile="RHEL-8-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="3400" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=0 --ksmeta="packages='python3,libselinux-python3'" --virt-auto-boot=0
}

addVms
