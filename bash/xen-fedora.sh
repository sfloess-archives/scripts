#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"


cobbler-exec system remove --name="fedora-27-atomic-xen"

cobbler-exec system add --name="fedora-27-atomic-xen" --hostname="fedora-atomic-xen" --profile="Fedora-27-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="2000" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="fedora-27-atomic"'
