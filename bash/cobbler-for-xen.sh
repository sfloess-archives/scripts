#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    remove-all

    cobbler signature update
    cobbler signature reload

    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'

    distro-add-atomic CentOS-7-Atomic-x86_64   /opt/distro/iso/CentOS-Atomic-Host-7-Installer.iso                --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic RHEL-7-Atomic-x86_64     /opt/distro/iso/rhel-atomic-installer-7.5.0-1.x86_64.iso          --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic Fedora-28-Atomic-x86_64  /opt/distro/iso/Fedora-AtomicHost-ostree-x86_64-28-20180816.1.iso --ksmeta="${FEDORA_KSMETA_DATA}"    --arch="x86_64" --os-version="fedora28"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    system-remove-all
    profile-remove-all

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"

    cobbler-exec profile add --name="CentOS-7-Atomic-x86_64"  --distro="CentOS-7-Atomic-x86_64"  --kickstart="${CENTOS_ATOMIC_KICKSTART}"
    cobbler-exec profile add --name="RHEL-7-Atomic-x86_64"    --distro="RHEL-7-Atomic-x86_64"    --kickstart="${RHEL_ATOMIC_KICKSTART}"
    cobbler-exec profile add --name="Fedora-28-Atomic-x86_64" --distro="Fedora-28-Atomic-x86_64" --kickstart="${FEDORA_ATOMIC_KICKSTART}"
}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"

    cobbler-exec system add --name="centos-atomic-xen"  --hostname="centos-atomic-xen" --profile="CentOS-7-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="50" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="centos-atomic" autopart="--no-home" ignoredisk="--only-use=xvda"' --netboot-enabled=1
    cobbler-exec system add --name="fedora-atomic-xen" --hostname="fedora-atomic-xen" --profile="Fedora-28-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="50" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="fedora-atomic" autopart="--no-home"' --netboot-enabled=1
    cobbler-exec system add --name="rhel-atomic-xen"    --hostname="rhel-atomic-xen"   --profile="RHEL-7-Atomic-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="50" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="rhel-atomic" autopart="--no-home"' --netboot-enabled=1
}

# ---------------------------------------------------------
# Add system definitions...
# ---------------------------------------------------------
addSystems() {
    system-remove-all

    addVms

    system-create-iso
}

# ---------------------------------------------------------
# Create the entire network...
# ---------------------------------------------------------
createNetwork() {
    remove-all

    cobbler sync

    addDistros
    addProfiles
    addSystems
}

# ---------------------------------------------------------
# Determine what to definitions to add...
# ---------------------------------------------------------
case "$1" in
    systems)
        addSystems
        ;;
    profiles)
        addProfiles
        ;;
    distros)
        addDistros
        ;;
    network)
        createNetwork
        ;;
    *)
	echo "Enter either systems, profiles, distros or network"
	exit 1
esac

