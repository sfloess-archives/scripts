#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../scripts/bash/cobbler-utils.sh

addDistros() {
    ENTERPISE_KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com packages=koan,redhat-lsb"
    FEDORA_KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com p0 packages=koan operatingSystem=fedora operatingSystemVersion=23"

    distro-add        CentOS-5.11-x86_64       /root/distro/iso/CentOS-5.11-x86_64-bin-DVD-1of2.iso     --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel5"
    distro-add        CentOS-6.7-x86_64        /root/distro/iso/CentOS-6.7-x86_64-bin-DVD1.iso          --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel6"
    distro-add        CentOS-7.1-x86_64        /root/distro/iso/CentOS-7-x86_64-Everything-1503-01.iso  --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-7.2-x86_64          /root/distro/iso/rhel-server-7.2-x86_64-dvd.iso          --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        Fedora-23-x86_64         /root/distro/iso/Fedora-Server-DVD-x86_64-23.iso         --ksmeta="${ENTERPISE_KSMETA_DATA}"

    distro-add-atomic CentOS-7.1-Atomic-x86_64 /root/distro/iso/CentOS-Atomic-Host-7-Installer.iso      --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic RHEL-7.2-Atomic-x86_64   /root/distro/iso/rhel-atomic-installer-7.2-10.x86_64.iso --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic Fedora-23-Atomic-x86_64  /root/distro/iso/Fedora-Cloud_Atomic-x86_64-23.iso       --ksmeta="${FEDORA_KSMETA_DATA}"    --arch="x86_64" --os-version="fedora23"
}

addRepos() {
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-5-extras"      --mirror="http://mirror.centos.org/centos-5/5/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-5-centosplus"  --mirror="http://mirror.centos.org/centos-5/5/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-5-updates"     --mirror="http://mirror.centos.org/centos-5/5/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-extras"      --mirror="http://mirror.centos.org/centos-6/6/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-centosplus"  --mirror="http://mirror.centos.org/centos-6/6/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-updates"     --mirror="http://mirror.centos.org/centos-6/6/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-extras"      --mirror="http://mirror.centos.org/centos-7/7/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-centosplus"  --mirror="http://mirror.centos.org/centos-7/7/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-updates"     --mirror="http://mirror.centos.org/centos-7/7/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Epel-5"               --mirror="http://dl.fedoraproject.org/pub/epel/5/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-6"               --mirror="http://dl.fedoraproject.org/pub/epel/6/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-7"               --mirror="http://dl.fedoraproject.org/pub/epel/7/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Fedora-23-everything" --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/23/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-23-updates"    --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/23/x86_64"
}

addProfiles() {
    CENTOS_5_REPOS="Epel-5 CentOS-5-extras CentOS-5-centosplus CentOS-5-updates"
    CENTOS_6_REPOS="Epel-6 CentOS-6-extras CentOS-6-centosplus CentOS-6-updates"
    CENTOS_7_REPOS="Epel-7 CentOS-7-extras CentOS-7-centosplus CentOS-7-updates"

    RHEL_REPOS="Epel-7"

    FEDORA_REPOS="Fedora-23-everything Fedora-23-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/system.ks"

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/centos-atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/rhel-atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/fedora-atomic.ks"

    cobbler-exec profile edit --name="CentOS-5.11-x86_64"       --distro="CentOS-5.11-x86_64"       --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_5_REPOS}"
    cobbler-exec profile edit --name="CentOS-6.7-x86_64"        --distro="CentOS-6.7-x86_64"        --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_6_REPOS}"
    cobbler-exec profile edit --name="CentOS-7.1-x86_64"        --distro="CentOS-7.1-x86_64"        --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_7_REPOS}"

    cobbler-exec profile edit --name="RHEL-7.2-x86_64"          --distro="RHEL-7.2-x86_64"          --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_REPOS}"
    cobbler-exec profile edit --name="Fedora-23-x86_64"         --distro="Fedora-23-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${FEDORA_REPOS}"

    cobbler-exec profile add  --name="CentOS-7.1-Atomic-x86_64" --distro="CentOS-7.1-Atomic-x86_64" --kickstart="${CENTOS_ATOMIC_KICKSTART}"
    cobbler-exec profile add  --name="RHEL-7.2-Atomic-x86_64"   --distro="RHEL-7.2-Atomic-x86_64"   --kickstart="${RHEL_ATOMIC_KICKSTART}"
    cobbler-exec profile add  --name="Fedora-23-Atomic-x86_64"  --distro="Fedora-23-Atomic-x86_64"  --kickstart="${FEDORA_ATOMIC_KICKSTART}"
}

addHosts() {
    cobbler-exec system add --name="host-1" --hostname="host-1" --profile="Fedora-23-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --virt-type="xenpv" --ksmeta="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com  authconfig=--nisdomain=flossware.com packages=koan,redhat-lsb lvmDisks=sda,sdb"
    cobbler-exec system add --name="host-2" --hostname="host-2" --profile="CentOS-7.1-x86_64" --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"   --ksmeta="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com  authconfig=--nisdomain=flossware.com packages=koan,redhat-lsb lvmDisks=sda"
}

addVms() {
    cobbler-exec system add --name="centos-workstation-xen"  --hostname="centos-workstation-xen"   --profile="CentOS-7.1-x86_64"        --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048"
    cobbler-exec system add --name="rhel-workstation-xen"    --hostname="rhel-workstation-xen"     --profile="RHEL-7.2-x86_64"          --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048"
    cobbler-exec system add --name="fedora-workstation-xen"  --hostname="fedora-workstation-xen"   --profile="Fedora-23-x86_64"         --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048"
    cobbler-exec system add --name="centos-atomic-xen"       --hostname="centos-atomic-xen"        --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048"
    cobbler-exec system add --name="rhel-atomic-xen"         --hostname="rhel-atomic-xen"          --profile="RHEL-7.2-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048"
    cobbler-exec system add --name="fedora-atomic-xen"       --hostname="fedora-atomic-xen"        --profile="Fedora-23-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048"

    cobbler-exec system add --name="centos-workstation"   --hostname="centos-workstation"    --profile="CentOS-7.1-x86_64"       --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="8192" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-workstation"     --hostname="rhel-workstation"      --profile="RHEL-7.2-x86_64"         --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="8192" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-workstation"   --hostname="fedora-workstation"    --profile="Fedora-23-x86_64"        --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="8192" --virt-bridge="bridge0"

    cobbler-exec system add --name="docker-builder"       --hostname="docker-builder"        --profile="RHEL-7.2-x86_64"         --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="8192" --virt-bridge="bridge0"

    cobbler-exec system add --name="rhel-atomic-master"   --hostname="rhel-atomic-master"   --profile="RHEL-7.2-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-atomic-pod-1"    --hostname="rhel-atomic-pod-1"    --profile="RHEL-7.2-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-atomic-pod-2"    --hostname="rhel-atomic-pod-2"    --profile="RHEL-7.2-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"

    cobbler-exec system add --name="centos-atomic-master" --hostname="centos-atomic-master" --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"
    cobbler-exec system add --name="centos-atomic-pod-1"  --hostname="centos-atomic-pod-1"  --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"
    cobbler-exec system add --name="centos-atomic-pod-2"  --hostname="centos-atomic-pod-2"  --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"

    cobbler-exec system add --name="fedora-atomic-master" --hostname="fedora-atomic-master" --profile="Fedora-23-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-atomic-pod-1"  --hostname="fedora-atomic-pod-1"  --profile="Fedora-23-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-atomic-pod-2"  --hostname="fedora-atomic-pod-2"  --profile="Fedora-23-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="4096" --virt-bridge="bridge0"
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