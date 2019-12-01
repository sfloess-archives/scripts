#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

distro-add-atomic Fedora-29-Atomic-x86_64  /opt/iso/Fedora-AtomicHost-ostree-x86_64-29-20191028.0.iso --arch="x86_64" --os-version="fedora29"

FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"

cobbler-exec profile add --name="Fedora-29-Atomic-x86_64" --distro="Fedora-29-Atomic-x86_64"

cobbler-exec system add --name="fedora-atomic"  --hostname="fedora-atomic" --profile="Fedora-29-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='clearpart="none --initlabel" hostname="fedora-atomic-kvm"' --virt-auto-boot=0
