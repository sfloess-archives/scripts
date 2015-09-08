#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../scripts/bash/cobbler-utils.sh

addDistros() {
    ENTERPISE_KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com packages=koan,redhat-lsb"
    FEDORA_KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com p0 packages=koan operatingSystem=fedora operatingSystemVersion=22"

    distro-add        CentOS-7.1-x86_64        /root/distro/iso/CentOS-7-x86_64-Everything-1503-01.iso --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-7.1-x86_64          /root/distro/iso/rhel-server-7.1-x86_64-dvd.iso         --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        Fedora-22-x86_64         /root/distro/iso/Fedora-Server-DVD-x86_64-22.iso        --ksmeta="${ENTERPISE_KSMETA_DATA}"

	distro-add-live   RHEL-7.1-Atomic-x86_64   /root/distro/iso/rhel-atomic-installer-7.1-1.x86_64.iso --ksmeta="${ENTERPISE_KSMETA_DATA}"
	distro-add-live   CentOS-7.1-Atomic-x86_64 /root/distro/iso/CentOS-Atomic-Host-7.1.2-Installer.iso --ksmeta="${ENTERPISE_KSMETA_DATA}"
	distro-add-live   Fedora-22-Atomic-x86_64  /root/distro/iso/Fedora-Cloud_Atomic-x86_64-22.iso      --ksmeta="${FEDORA_KSMETA_DATA}"
}

addRepos() {
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-extras"      --mirror="http://mirror.centos.org/centos-7/7/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-centosplus"  --mirror="http://mirror.centos.org/centos-7/7/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-updates"     --mirror="http://mirror.centos.org/centos-7/7/updates/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-7"               --mirror="http://dl.fedoraproject.org/pub/epel/7/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-22-everything" --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/22/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-22-updates"    --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/22/x86_64"
}

addProfiles() {
    CENTOS_REPOS="Epel-7 CentOS-7-extras CentOS-7-centosplus CentOS-7-updates"
    RHEL_REPOS="Epel-7"
    FEDORA_REPOS="Fedora-22-everything Fedora-22-updates"
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/system.ks"
    ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/atomic.ks"

    cobbler-exec profile edit --name="CentOS-7.1-x86_64"        --distro="CentOS-7.1-x86_64"        --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_REPOS}"
    cobbler-exec profile edit --name="RHEL-7.1-x86_64"          --distro="RHEL-7.1-x86_64"          --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_REPOS}"
    cobbler-exec profile edit --name="Fedora-22-x86_64"         --distro="Fedora-22-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${FEDORA_REPOS}"
    cobbler-exec profile add  --name="RHEL-7.1-Atomic-x86_64"   --distro="RHEL-7.1-Atomic-x86_64"   --kickstart="${ATOMIC_KICKSTART}"
    cobbler-exec profile add  --name="CentOS-7.1-Atomic-x86_64" --distro="CentOS-7.1-Atomic-x86_64" --kickstart="${ATOMIC_KICKSTART}"
    cobbler-exec profile add  --name="Fedora-22-Atomic-x86_64"  --distro="Fedora-22-Atomic-x86_64"  --kickstart="${ATOMIC_KICKSTART}"
}

addHosts() {
    cobbler-exec system add --name="host-1" --hostname="host-1" --profile="CentOS-7.1-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8"
    cobbler-exec system add --name="host-2" --hostname="host-2" --profile="CentOS-7.1-x86_64" --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"
}

addVms() {
    cobbler-exec system add --name="centos-1"  --hostname="centos-1"  --profile="CentOS-7.1-x86_64"        --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"
    cobbler-exec system add --name="rhel-1"    --hostname="rhel-1"    --profile="RHEL-7.1-x86_64"          --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"

    cobbler-exec system add --name="rhel-atomic-1"   --hostname="rhel-atomic-1"   --profile="RHEL-7.1-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"
    cobbler-exec system add --name="rhel-atomic-2"   --hostname="rhel-atomic-2"   --profile="RHEL-7.1-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"
    cobbler-exec system add --name="rhel-atomic-3"   --hostname="rhel-atomic-3"   --profile="RHEL-7.1-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"
    cobbler-exec system add --name="rhel-atomic-4"   --hostname="rhel-atomic-4"   --profile="RHEL-7.1-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"
    cobbler-exec system add --name="centos-atomic-1" --hostname="centos-atomic-1" --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"
    cobbler-exec system add --name="centos-atomic-2" --hostname="centos-atomic-2" --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"
    cobbler-exec system add --name="centos-atomic-3" --hostname="centos-atomic-3" --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"
    cobbler-exec system add --name="centos-atomic-4" --hostname="centos-atomic-4" --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096"
}

addSystems() {
    system-remove-all

    addHosts
    addVms

    system-create-iso
}

createNetwork() {
    remove-all

    cobbler sync

    addDistros
    addRepos
    addProfiles
    addSystems
}

createNetwork