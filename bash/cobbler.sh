#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    remove-all

    #cobbler signature update
    #cobbler signature reload

    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'
    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0'

    distro-add        CentOS-7-x86_64          /opt/distro/iso/CentOS-7-x86_64-DVD-1810.iso                      --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-7-x86_64            /opt/distro/iso/rhel-server-7.6-x86_64-dvd.iso                    --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        Fedora-29-x86_64         /opt/distro/iso/Fedora-Server-dvd-x86_64-29-1.2.iso               --ksmeta="${FEDORA_KSMETA_DATA}"

    distro-add-atomic CentOS-7-Atomic-x86_64   /opt/distro/iso/CentOS-Atomic-Host-7-Installer.iso                --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic RHEL-7-Atomic-x86_64     /opt/distro/iso/rhel-atomic-installer-7.6.0-1.x86_64.iso          --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic Fedora-29-Atomic-x86_64  /opt/distro/iso/Fedora-AtomicHost-ostree-x86_64-29-20181025.1.iso --ksmeta="${FEDORA_KSMETA_DATA}"    --arch="x86_64" --os-version="fedora29"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
    repo-remove-all

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Epel-7"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/7/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Fedora-29-everything" --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/29/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-29-updates"    --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/29/Everything/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    system-remove-all
    profile-remove-all
    addRepos

    CENTOS_7_REPOS="Epel-7 CentOS-7-extras CentOS-7-centosplus CentOS-7-updates"

    RHEL_7_REPOS="Epel-7"

    FEDORA_REPOS="Fedora-29-everything Fedora-29-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"

    cobbler-exec profile add --name="CentOS-7-x86_64"         --distro="CentOS-7-x86_64"         --repos="${CENTOS_7_REPOS}" --kickstart="${STANDARD_KICKSTART}"
    cobbler-exec profile add --name="RHEL-7-x86_64"           --distro="RHEL-7-x86_64"           --repos="${RHEL_7_REPOS}" --kickstart="${STANDARD_KICKSTART}"
    cobbler-exec profile add --name="Fedora-29-x86_64"        --distro="Fedora-29-x86_64"        --repos="${FEDORA_REPOS}" --kickstart="${STANDARD_KICKSTART}"

    cobbler-exec profile add --name="CentOS-7-Atomic-x86_64"  --distro="CentOS-7-Atomic-x86_64"  --kickstart="${CENTOS_ATOMIC_KICKSTART}"
    cobbler-exec profile add --name="RHEL-7-Atomic-x86_64"    --distro="RHEL-7-Atomic-x86_64"    --kickstart="${RHEL_ATOMIC_KICKSTART}"
    cobbler-exec profile add --name="Fedora-29-Atomic-x86_64" --distro="Fedora-29-Atomic-x86_64" --kickstart="${FEDORA_ATOMIC_KICKSTART}"
}

# ---------------------------------------------------------
# Add host definitions...
# ---------------------------------------------------------
addHosts() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="cloud-host-01" --hostname="cloud-host-01" --profile="CentOS-7-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --virt-type="xenpv" --ksmeta='lvmDisks="sda sdb" completionMethod=reboot'
    cobbler-exec system add --name="cloud-host-02" --hostname="cloud-host-02" --profile="RHEL-7-x86_64"   --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc" completionMethod=reboot'
    cobbler-exec system add --name="cloud-host-03" --hostname="cloud-host-03" --profile="RHEL-7-x86_64"   --interface="eth0" --mac-address="00:21:9B:32:5F:78" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc" completionMethod=reboot' 

    cobbler-exec system add --name="laptop" --hostname="laptop" --profile="RHEL-7-x86_64"   --interface="eth0" --mac-address="00:8C:FA:2D:45:05" --virt-type="kvm"   --ksmeta='autopart="--nohome" lvmDisks="sda" completionMethod="reboot"'
}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"

    cobbler-exec system add --name="centos-kvm"  --hostname="centos-kvm"  --profile="CentOS-7-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="fedora-kvm" --hostname="fedora-kvm" --profile="Fedora-29-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="rhel-kvm"    --hostname="rhel-kvm"    --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="centos-xen" --hostname="centos-xen" --profile="CentOS-7-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='completionMethod=poweroff' --virt-auto-boot=0
    cobbler-exec system add --name="fedora-xen" --hostname="fedora-xen" --profile="Fedora-29-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='completionMethod=poweroff' --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="rhel-xen"    --hostname="rhel-xen"    --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='completionMethod=poweroff' --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="centos-atomic-kvm"  --hostname="centos-atomic-kvm" --profile="CentOS-7-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="centos-atomic"' --kickstart="${CENTOS_ATOMIC_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="fedora-atomic-kvm" --hostname="fedora-atomic-kvm" --profile="Fedora-29-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='clearpart="none --initlabel" hostname="fedora-atomic-kvm"' --virt-auto-boot=0
    cobbler-exec system add --name="rhel-atomic-kvm"    --hostname="rhel-atomic-kvm"   --profile="RHEL-7-Atomic-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="rhel-atomic"' --kickstart="${RHEL_ATOMIC_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="centos-atomic-xen" --hostname="centos-atomic-xen" --profile="CentOS-7-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='autopart="--type=lvm" clearpart="all --initlabel"' --virt-auto-boot=0
    cobbler-exec system add --name="fedora-atomic-xen" --hostname="fedora-atomic-xen" --profile="Fedora-29-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="50" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="fedora-atomic"' --virt-auto-boot=0
    cobbler-exec system add --name="rhel-atomic-xen"    --hostname="rhel-atomic-xen"   --profile="RHEL-7-Atomic-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="50" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="rhel-atomic"' --virt-auto-boot=0

    cobbler-exec system add --name="fedora-workstation" --hostname="fedora-workstation"  --profile="Fedora-29-x86_64"  --interface="eth0" --mac-address="52:54:00:62:d7:a8" --virt-type="kvm" --virt-file-size="50"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
cobbler-exec system add --name="cobbler-kvm" --hostname="cobbler-kvm" --profile="Centos-7-x86_64" --interface="eth0"  --mac-address="00:16:3e:67:a5:62" --ksmeta='completionMethod=poweroff' --virt-type="kvm" --virt-file-size="50" --virt-ram="2048" --virt-bridge="bridge0" --virt-auto-boot=0

    cobbler-exec system add --name="fedora-workstation-xen" --hostname="fedora-workstation-xen"  --profile="Fedora-29-x86_64"  --interface="eth0" --mac-address="00:16:3e:4f:0c:d1" --virt-type="xenpv" --virt-file-size="50"  --virt-ram="3400" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="cobbler-xen" --hostname="cobbler-xen" --profile="Centos-7-x86_64" --interface="eth0"  --mac-address="00:16:3e:45:41:11" --virt-type="xenpv" --virt-file-size="50" --virt-ram="2048" --virt-bridge="bridge0" --virt-auto-boot=0
}

# ---------------------------------------------------------
# Add system definitions...
# ---------------------------------------------------------
addSystems() {
    system-remove-all

    addHosts
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
    addRepos
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
    repos)
        addRepos
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
	echo "Enter either systems, repos, profiles, distros or network"
	exit 1
esac