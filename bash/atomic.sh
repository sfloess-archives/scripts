#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

cobbler distro remove --recursive --name=CentOS-7-Atomic-x86_64
cobbler distro remove --recursive --name=Fedora-29-Atomic-x86_64
cobbler distro remove --recursive --name=RHEL-7-Atomic-x86_64

distro-add-atomic CentOS-7-Atomic-x86_64   /opt/iso/CentOS-Atomic-Host-Installer.iso --arch="x86_64" --os-version="rhel7"
distro-add-atomic Fedora-29-Atomic-x86_64  /opt/iso/Fedora-AtomicHost-ostree-x86_64-29-20181025.1.iso --arch="x86_64" --os-version="fedora29"
distro-add-atomic RHEL-7-Atomic-x86_64     /opt/iso/rhel-atomic-installer-7.7.0-1.x86_64.iso --arch="x86_64" --os-version="rhel7"

CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"
RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"

cobbler-exec profile add --name="CentOS-7-Atomic-x86_64"  --distro="CentOS-7-Atomic-x86_64"
cobbler-exec profile add --name="Fedora-29-Atomic-x86_64" --distro="Fedora-29-Atomic-x86_64"
cobbler-exec profile add --name="RHEL-7-Atomic-x86_64"    --distro="RHEL-7-Atomic-x86_64"

cobbler-exec system add --name="centos-7-atomic"  --hostname="centos-7-atomic" --profile="CentOS-7-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="centos-7-atomic"' --kickstart="${CENTOS_ATOMIC_KICKSTART}" --virt-auto-boot=0
cobbler-exec system add --name="rhel-7-atomic"    --hostname="rhel-7-atomic"   --profile="RHEL-7-Atomic-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="rhel-7-atomic"' --kickstart="${RHEL_ATOMIC_KICKSTART}" --virt-auto-boot=0
cobbler-exec system add --name="fedora-29-atomic"  --hostname="fedora-29-atomic" --profile="Fedora-29-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='clearpart="none --initlabel" hostname="fedora-29-atomic-kvm"' --virt-auto-boot=0
