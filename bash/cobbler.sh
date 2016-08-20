#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../scripts/bash/cobbler-utils.sh

addDistros() {
    ENTERPISE_KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com packages=koan,redhat-lsb"
    FEDORA_KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com p0 packages=koan operatingSystem=fedora operatingSystemVersion=23"

    distro-add        CentOS-7.2-x86_64        /root/distro/iso/CentOS-7-x86_64-Everything-1511.iso     --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-7.2-x86_64          /root/distro/iso/rhel-server-7.2-x86_64-dvd.iso          --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        Fedora-23-x86_64         /root/distro/iso/Fedora-Server-DVD-x86_64-23.iso         --ksmeta="${FEDORA_KSMETA_DATA}"

    distro-add-rhev   RHEVH-7.2-x86_64         /root/distro/iso/rhev-hypervisor7-7.2-20160302.1.iso     --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7" --breed="redhat"

    distro-add-atomic CentOS-7.1-Atomic-x86_64 /root/distro/iso/CentOS-Atomic-Host-7-Installer.iso      --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic RHEL-7.2-Atomic-x86_64   /root/distro/iso/rhel-atomic-installer-7.2-10.x86_64.iso --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic Fedora-23-Atomic-x86_64  /root/distro/iso/Fedora-Cloud_Atomic-x86_64-23.iso       --ksmeta="${FEDORA_KSMETA_DATA}"    --arch="x86_64" --os-version="fedora23"
}

addRepos() {
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
    CENTOS_7_REPOS="Epel-7 CentOS-7-extras CentOS-7-centosplus CentOS-7-updates"

    RHEL_REPOS="Epel-7"

    FEDORA_23_REPOS="Fedora-23-everything Fedora-23-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/system.ks"

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/centos-atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/rhel-atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/fedora-atomic.ks"

    cobbler-exec profile edit --name="CentOS-7.2-x86_64"        --distro="CentOS-7.2-x86_64"        --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_7_REPOS}"

    cobbler-exec profile edit --name="RHEL-7.2-x86_64"          --distro="RHEL-7.2-x86_64"          --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_REPOS}"
    cobbler-exec profile edit --name="Fedora-23-x86_64"         --distro="Fedora-23-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${FEDORA_23_REPOS}"

    cobbler-exec profile add  --name="RHEVH-7.2-x86_64"         --distro="RHEVH-7.2-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_REPOS}"

    cobbler-exec profile add  --name="CentOS-7.1-Atomic-x86_64" --distro="CentOS-7.1-Atomic-x86_64" --kickstart="${CENTOS_ATOMIC_KICKSTART}"
    cobbler-exec profile add  --name="RHEL-7.2-Atomic-x86_64"   --distro="RHEL-7.2-Atomic-x86_64"   --kickstart="${RHEL_ATOMIC_KICKSTART}"
    cobbler-exec profile add  --name="Fedora-23-Atomic-x86_64"  --distro="Fedora-23-Atomic-x86_64"  --kickstart="${FEDORA_ATOMIC_KICKSTART}"
}

addHosts() {
    cobbler-exec system add --name="host-1" --hostname="host-1" --profile="CentOS-7.2-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --virt-type="xenpv" --ksmeta="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com authconfig=--nisdomain=flossware.com packages=koan,redhat-lsb lvmDisks=sda,sdb"

    cobbler-exec system add --name="host-2" --hostname="host-2" --profile="RHEVH-7.2-x86_64" --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"   --ksmeta="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com  authconfig=--nisdomain=flossware.com packages=koan,redhat-lsb lvmDisks=sda,sdb"
}

addXenVms() {
    cobbler-exec system add --name="centos-xen"  --hostname="centos-xen"   --profile="CentOS-7.2-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'
    cobbler-exec system add --name="rhel-xen"    --hostname="rhel-xen"     --profile="RHEL-7.2-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'
    cobbler-exec system add --name="fedora-xen"  --hostname="fedora-xen"   --profile="Fedora-23-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'

    cobbler-exec system add --name="centos-atomic-xen"  --hostname="centos-atomic-xen" --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'
    cobbler-exec system add --name="rhel-atomic-xen"    --hostname="rhel-atomic-xen"   --profile="RHEL-7.2-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'
    cobbler-exec system add --name="fedora-atomic-xen"  --hostname="fedora-atomic-xen" --profile="Fedora-23-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"  --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'

    cobbler-exec system add --name="workstation"        --hostname="workstation"   --profile="RHEL-7.2-x86_64"              --interface="eth0"  --mac-address="00:16:3e:1c:97:ac" --virt-type="xenpv" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'
    cobbler-exec system add --name="atomic-master"      --hostname="atomic-master" --profile="RHEL-7.2-Atomic-x86_64"       --interface="eth0"  --mac-address="00:16:3e:39:ce:5e" --virt-type="xenpv" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1 --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'
    cobbler-exec system add --name="db"                 --hostname="db"            --profile="RHEL-7.2-x86_64"              --interface="eth0"  --mac-address="00:16:3e:50:39:07" --virt-type="xenpv" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1 --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'
    cobbler-exec system add --name="pulp"               --hostname="pulp"          --profile="RHEL-7.2-x86_64"              --interface="eth0"  --mac-address="00:16:3e:4e:fc:64" --virt-type="xenpv" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'
    cobbler-exec system add --name="solr"               --hostname="solr"          --profile="RHEL-7.2-x86_64"              --interface="eth0"  --mac-address="00:16:3e:7f:38:c8" --virt-type="xenpv" --virt-file-size="100" --virt-ram="3400" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta='bootloader="--location=mbr --boot-drive=xvda"'
}

addKvmVms() {
    cobbler-exec system add --name="centos-kvm"   --hostname="centos-kvm"   --profile="CentOS-7.2-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-kvm"     --hostname="rhel-kvm"     --profile="RHEL-7.2-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-kvm"   --hostname="fedora-kvm"   --profile="Fedora-23-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"

    cobbler-exec system add --name="builder"      --hostname="builder"     --profile="RHEL-7.2-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="50" --virt-ram="8192" --virt-bridge="bridge0"

    cobbler-exec system add --name="atomic-01" --hostname="atomic-01"    --profile="RHEL-7.2-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="50" --virt-ram="8192" --virt-bridge="bridge0"
    cobbler-exec system add --name="atomic-02" --hostname="atomic-02"    --profile="RHEL-7.2-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="50" --virt-ram="8192" --virt-bridge="bridge0"
    cobbler-exec system add --name="atomic-03" --hostname="atomic-03"    --profile="RHEL-7.2-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="50" --virt-ram="8192" --virt-bridge="bridge0"

    cobbler-exec system add --name="rhel-atomic-kvm"   --hostname="rhel-atomic-kvm"   --profile="RHEL-7.2-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="centos-atomic-kvm" --hostname="centos-atomic-kvm" --profile="CentOS-7.1-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-atomic-kvm" --hostname="fedora-atomic-kvm" --profile="Fedora-23-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0"
}

addVms() {
    addXenVms
    addKvmVms
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