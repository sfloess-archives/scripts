#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    remove-all

    cobbler signature update

    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="koan redhat-lsb"'
    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0 packages="koan"'

    distro-add        CentOS-5-x86_64          /root/distro/iso/CentOS-5.11-x86_64-bin-DVD-1of2.iso           --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        CentOS-6-x86_64          /root/distro/iso/CentOS-6.9-x86_64-bin-DVD1.iso                --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        CentOS-7-x86_64          /root/distro/iso/CentOS-7-x86_64-Everything-1708.iso           --ksmeta="${ENTERPISE_KSMETA_DATA}"

    distro-add        RHEL-5-x86_64            /root/distro/iso/rhel-server-5.11-x86_64-dvd.iso               --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-6-x86_64            /root/distro/iso/rhel-server-6.9-x86_64-dvd.iso                --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-7-x86_64            /root/distro/iso/rhel-server-7.4-x86_64-dvd.iso                --ksmeta="${ENTERPISE_KSMETA_DATA}"

    distro-add        Fedora-26-x86_64         /root/distro/iso/Fedora-Server-dvd-x86_64-26-1.5.iso           --ksmeta="${FEDORA_KSMETA_DATA}"

    distro-add-rhev   RHEVH-4-x86_64           /root/distro/iso/RHVH-4.1-20170706.1-RHVH-x86_64-dvd1.iso      --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7" --breed="redhat"

    distro-add-atomic CentOS-7-Atomic-x86_64   /root/distro/iso/CentOS-Atomic-Host-7-Installer.iso            --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic RHEL-7-Atomic-x86_64     /root/distro/iso/rhel-atomic-installer-7.4.0-1.x86_64.iso      --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic Fedora-26-Atomic-x86_64  /root/distro/iso/Fedora-Atomic-ostree-x86_64-26-20170920.0.iso --ksmeta="${FEDORA_KSMETA_DATA}"    --arch="x86_64" --os-version="fedora26"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
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

    cobbler-exec repo add --mirror-locally="0" --name="Fedora-26-everything" --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/26/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-26-updates"    --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/26/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    system-remove-all
    profile-remove-all

    CENTOS_5_REPOS="Epel-5 CentOS-5-extras CentOS-5-centosplus CentOS-5-updates"
    CENTOS_6_REPOS="Epel-6 CentOS-6-extras CentOS-6-centosplus CentOS-6-updates"
    CENTOS_7_REPOS="Epel-7 CentOS-7-extras CentOS-7-centosplus CentOS-7-updates"

    RHEL_5_REPOS="Epel-5"
    RHEL_6_REPOS="Epel-6"
    RHEL_7_REPOS="Epel-7"

    FEDORA_REPOS="Fedora-26-everything Fedora-26-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"

    cobbler-exec profile add --name="CentOS-5-x86_64"         --distro="CentOS-5-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_5_REPOS}"
    cobbler-exec profile add --name="CentOS-6-x86_64"         --distro="CentOS-6-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_6_REPOS}"
    cobbler-exec profile add --name="CentOS-7-x86_64"         --distro="CentOS-7-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_7_REPOS}"

    cobbler-exec profile add --name="RHEL-5-x86_64"           --distro="RHEL-5-x86_64"           --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_5_REPOS}"
    cobbler-exec profile add --name="RHEL-6-x86_64"           --distro="RHEL-6-x86_64"           --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_6_REPOS}"
    cobbler-exec profile add --name="RHEL-7-x86_64"           --distro="RHEL-7-x86_64"           --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_7_REPOS}"

    cobbler-exec profile add --name="Fedora-26-x86_64"        --distro="Fedora-26-x86_64"        --kickstart="${STANDARD_KICKSTART}" --repos="${FEDORA_REPOS}"

    cobbler-exec profile add --name="RHEVH-4-x86_64"          --distro="RHEVH-4-x86_64"          --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_7_REPOS}"

    cobbler-exec profile add --name="CentOS-7-Atomic-x86_64"  --distro="CentOS-7-Atomic-x86_64"  --kickstart="${CENTOS_ATOMIC_KICKSTART}"
    cobbler-exec profile add --name="RHEL-7-Atomic-x86_64"    --distro="RHEL-7-Atomic-x86_64"    --kickstart="${RHEL_ATOMIC_KICKSTART}"
    cobbler-exec profile add --name="Fedora-26-Atomic-x86_64" --distro="Fedora-26-Atomic-x86_64" --kickstart="${FEDORA_ATOMIC_KICKSTART}"
}

# ---------------------------------------------------------
# Add host definitions...
# ---------------------------------------------------------
addHosts() {
    cobbler-exec system add --name="host-1" --hostname="host-1" --profile="CentOS-7-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --virt-type="xenpv" --ksmeta='lvmDisks="sda sdb"'
    cobbler-exec system add --name="host-2" --hostname="host-2" --profile="RHEL-7-x86_64"   --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc"'
    cobbler-exec system add --name="host-3" --hostname="host-3" --profile="RHEL-7-x86_64"   --interface="eth0" --mac-address="00:21:9B:32:5F:78" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc"'
}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    cobbler-exec system add --name="centos-5-kvm"  --hostname="centos-5-kvm"  --profile="CentOS-5-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" 
    cobbler-exec system add --name="centos-6-kvm"  --hostname="centos-6-kvm"  --profile="CentOS-6-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="centos-7-kvm"  --hostname="centos-7-kvm"  --profile="CentOS-7-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-26-kvm" --hostname="fedora-26-kvm" --profile="Fedora-26-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-5-kvm"    --hostname="rhel-5-kvm"    --profile="RHEL-5-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-6-kvm"    --hostname="rhel-6-kvm"    --profile="RHEL-6-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-7-kvm"    --hostname="rhel-7-kvm"    --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"

    cobbler-exec system add --name="centos-7-atomic-kvm"  --hostname="centos-atomic-kvm" --profile="CentOS-7-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="centos-7-atomic"'
    cobbler-exec system add --name="fedora-26-atomic-kvm" --hostname="fedora-atomic-kvm" --profile="Fedora-26-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="fedora-26-atomic"'
    cobbler-exec system add --name="rhel-7-atomic-kvm"    --hostname="rhel-atomic-kvm"   --profile="RHEL-7-Atomic-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="rhel-7-atomic"'

    cobbler-exec system add --name="workstation"    --hostname="workstation"   --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="00:16:3e:79:79:11" --virt-type="kvm" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4
    cobbler-exec system add --name="db"             --hostname="db"            --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="00:16:3e:63:0a:b7" --virt-type="kvm" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1
    cobbler-exec system add --name="atomic-master"  --hostname="atomic-master" --profile="RHEL-7-Atomic-x86_64" --interface="eth0" --mac-address="00:16:3e:50:51:24" --virt-type="kvm" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1
    cobbler-exec system add --name="builder"        --hostname="builder"       --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="00:16:3e:27:d5:50" --virt-type="kvm" --virt-file-size="250" --virt-ram="16384"  --virt-bridge="bridge0" --virt-cpus=4
    cobbler-exec system add --name="solr"           --hostname="solr"          --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="00:16:3e:42:2e:5d" --virt-type="kvm" --virt-file-size="100" --virt-ram="16384" --virt-bridge="bridge0" --virt-cpus=4
    cobbler-exec system add --name="neo4j"          --hostname="neo4j"         --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="52:54:00:5d:f3:1c" --virt-type="kvm" --virt-file-size="250" --virt-ram="16384"  --virt-bridge="bridge0" --virt-cpus=4
    cobbler-exec system add --name="plex"           --hostname="plex"          --profile="Fedora-26-x86_64"     --interface="eth0" --mac-address="00:16:3e:03:72:d0" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4

    cobbler-exec system add --name="fedora-workstation" --hostname="fedora-workstation"  --profile="Fedora-26-x86_64"  --interface="eth0" --mac-address="52:54:00:62:d7:a8" --virt-type="kvm" --virt-file-size="50"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4
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
    profiles)
        addProfiles
        ;;
    distros)
        addDistros
        ;;
    *)
        createNetwork
        ;;
esac
