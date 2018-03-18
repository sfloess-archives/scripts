#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    remove-all

    #cobbler signature update

    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="koan redhat-lsb"'
    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0 packages="koan"'

    distro-add        CentOS-5-x86_64          /root/distro/iso/CentOS-5.11-x86_64-bin-DVD-1of2.iso           --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        CentOS-6-x86_64          /root/distro/iso/CentOS-6.9-x86_64-bin-DVD1.iso                --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        CentOS-7-x86_64          /root/distro/iso/CentOS-7-x86_64-Everything-1708.iso           --ksmeta="${ENTERPISE_KSMETA_DATA}"

    distro-add        RHEL-5-x86_64            /root/distro/iso/rhel-server-5.11-x86_64-dvd.iso               --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-6-x86_64            /root/distro/iso/rhel-server-6.9-x86_64-dvd.iso                --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-7-x86_64            /root/distro/iso/rhel-server-7.4-x86_64-dvd.iso                --ksmeta="${ENTERPISE_KSMETA_DATA}"

    distro-add        Fedora-27-x86_64         /root/distro/iso/Fedora-Server-dvd-x86_64-27-1.6.iso           --ksmeta="${FEDORA_KSMETA_DATA}"

    distro-add-atomic CentOS-7-Atomic-x86_64   /root/distro/iso/CentOS-Atomic-Host-7-Installer.iso            --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic RHEL-7-Atomic-x86_64     /root/distro/iso/rhel-atomic-installer-7.4.4-1.x86_64.iso      --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic Fedora-27-Atomic-x86_64  /root/distro/iso/Fedora-Atomic-ostree-x86_64-27-20180212.2.iso --ksmeta="${FEDORA_KSMETA_DATA}"    --arch="x86_64" --os-version="fedora27"

    distro-add-rhev   RHEVH-4-x86_64           /root/distro/iso/RHVH-4.1-20180128.0-RHVH-x86_64-dvd1.iso      --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7" --breed="redhat"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
    repo-remove-all

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-5-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-5/5/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-5-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-5/5/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-5-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-5/5/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-6/6/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-6/6/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-6/6/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Epel-5"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/5/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-6"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/6/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-7"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/7/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Fedora-27-everything" --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/27/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-27-updates"    --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/27/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    system-remove-all
    profile-remove-all
    addRepos

    CENTOS_5_REPOS="Epel-5 CentOS-5-extras CentOS-5-centosplus CentOS-5-updates"
    CENTOS_6_REPOS="Epel-6 CentOS-6-extras CentOS-6-centosplus CentOS-6-updates"
    CENTOS_7_REPOS="Epel-7 CentOS-7-extras CentOS-7-centosplus CentOS-7-updates"

    RHEL_5_REPOS="Epel-5"
    RHEL_6_REPOS="Epel-6"
    RHEL_7_REPOS="Epel-7"

    FEDORA_REPOS="Fedora-27-everything Fedora-27-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"

    cobbler-exec profile add --name="CentOS-5-x86_64"         --distro="CentOS-5-x86_64"         --repos="${CENTOS_5_REPOS}" --kickstart="${STANDARD_KICKSTART}"
    cobbler-exec profile add --name="CentOS-6-x86_64"         --distro="CentOS-6-x86_64"         --repos="${CENTOS_6_REPOS}" --kickstart="${STANDARD_KICKSTART}"
    cobbler-exec profile add --name="CentOS-7-x86_64"         --distro="CentOS-7-x86_64"         --repos="${CENTOS_7_REPOS}" --kickstart="${STANDARD_KICKSTART}"

    cobbler-exec profile add --name="RHEL-5-x86_64"           --distro="RHEL-5-x86_64"           --repos="${RHEL_5_REPOS}" --kickstart="${STANDARD_KICKSTART}"
    cobbler-exec profile add --name="RHEL-6-x86_64"           --distro="RHEL-6-x86_64"           --repos="${RHEL_6_REPOS}" --kickstart="${STANDARD_KICKSTART}"
    cobbler-exec profile add --name="RHEL-7-x86_64"           --distro="RHEL-7-x86_64"           --repos="${RHEL_7_REPOS}" --kickstart="${STANDARD_KICKSTART}"

    cobbler-exec profile add --name="Fedora-27-x86_64"        --distro="Fedora-27-x86_64"        --repos="${FEDORA_REPOS}" --kickstart="${STANDARD_KICKSTART}"

    cobbler-exec profile add --name="RHEVH-4-x86_64"          --distro="RHEVH-4-x86_64"          --repos="${RHEL_7_REPOS}" --kickstart="${STANDARD_KICKSTART}"

    cobbler-exec profile add --name="CentOS-7-Atomic-x86_64"  --distro="CentOS-7-Atomic-x86_64"  --kickstart="${CENTOS_ATOMIC_KICKSTART}"
    cobbler-exec profile add --name="RHEL-7-Atomic-x86_64"    --distro="RHEL-7-Atomic-x86_64"    --kickstart="${RHEL_ATOMIC_KICKSTART}"
    cobbler-exec profile add --name="Fedora-27-Atomic-x86_64" --distro="Fedora-27-Atomic-x86_64" --kickstart="${FEDORA_ATOMIC_KICKSTART}"
}

# ---------------------------------------------------------
# Add host definitions...
# ---------------------------------------------------------
addHosts() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="host-1" --hostname="host-1" --profile="Fedora-27-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --virt-type="xenpv" --ksmeta='lvmDisks="sda sdb"'
    cobbler-exec system add --name="host-2" --hostname="host-2" --profile="RHEL-7-x86_64"   --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc"'
    cobbler-exec system add --name="host-3" --hostname="host-3" --profile="RHEL-7-x86_64"   --interface="eth0" --mac-address="00:21:9B:32:5F:78" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc"'

    cobbler-exec system add --name="laptop" --hostname="laptop" --profile="RHEL-7-x86_64"   --interface="eth0" --mac-address="00:8c:fa:2d:45:05" --virt-type="kvm"
}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"

    cobbler-exec system add --name="centos-5-kvm"  --hostname="centos-5-kvm"  --profile="CentOS-5-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" 
    cobbler-exec system add --name="centos-5-kvm"  --hostname="centos-5-kvm"  --profile="CentOS-5-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" 
    cobbler-exec system add --name="centos-6-kvm"  --hostname="centos-6-kvm"  --profile="CentOS-6-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="centos-7-kvm"  --hostname="centos-7-kvm"  --profile="CentOS-7-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-27-kvm" --hostname="fedora-27-kvm" --profile="Fedora-27-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-5-kvm"    --hostname="rhel-5-kvm"    --profile="RHEL-5-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-6-kvm"    --hostname="rhel-6-kvm"    --profile="RHEL-6-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-7-kvm"    --hostname="rhel-7-kvm"    --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"

    cobbler-exec system add --name="centos-6-xen"  --hostname="centos-6-xen"  --profile="CentOS-6-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="centos-7-xen"  --hostname="centos-7-xen"  --profile="CentOS-7-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-27-xen" --hostname="fedora-27-xen" --profile="Fedora-27-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-5-xen"    --hostname="rhel-5-xen"    --profile="RHEL-5-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-6-xen"    --hostname="rhel-6-xen"    --profile="RHEL-6-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-7-xen"    --hostname="rhel-7-xen"    --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"

    cobbler-exec system add --name="centos-7-atomic-kvm"  --hostname="centos-atomic-kvm" --profile="CentOS-7-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="centos-7-atomic"'
    cobbler-exec system add --name="fedora-27-atomic-kvm" --hostname="fedora-atomic-kvm" --profile="Fedora-27-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="fedora-27-atomic"'
    cobbler-exec system add --name="rhel-7-atomic-kvm"    --hostname="rhel-atomic-kvm"   --profile="RHEL-7-Atomic-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="rhel-7-atomic"'

    cobbler-exec system add --name="centos-7-atomic-xen"  --hostname="centos-atomic-xen" --profile="CentOS-7-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="centos-7-atomic"'
    cobbler-exec system add --name="fedora-27-atomic-xen" --hostname="fedora-atomic-xen" --profile="Fedora-27-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="fedora-27-atomic"'
    cobbler-exec system add --name="rhel-7-atomic-xen"    --hostname="rhel-atomic-xen"   --profile="RHEL-7-Atomic-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="rhel-7-atomic"'

    cobbler-exec system add --name="workstation"    --hostname="workstation"   --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="00:16:3e:79:79:11" --virt-type="kvm" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4
    cobbler-exec system add --name="db"             --hostname="db"            --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="00:16:3e:63:0a:b7" --virt-type="kvm" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1
    cobbler-exec system add --name="atomic-master"  --hostname="atomic-master" --profile="RHEL-7-Atomic-x86_64" --interface="eth0" --mac-address="00:16:3e:50:51:24" --virt-type="kvm" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1
    cobbler-exec system add --name="builder"        --hostname="builder"       --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="00:16:3e:27:d5:50" --virt-type="kvm" --virt-file-size="250" --virt-ram="16384"  --virt-bridge="bridge0" --virt-cpus=4
    cobbler-exec system add --name="solr"           --hostname="solr"          --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="00:16:3e:42:2e:5d" --virt-type="kvm" --virt-file-size="100" --virt-ram="16384" --virt-bridge="bridge0" --virt-cpus=4
    cobbler-exec system add --name="neo4j"          --hostname="neo4j"         --profile="RHEL-7-x86_64"        --interface="eth0" --mac-address="52:54:00:5d:f3:1c" --virt-type="kvm" --virt-file-size="250" --virt-ram="16384"  --virt-bridge="bridge0" --virt-cpus=4
    cobbler-exec system add --name="plex"           --hostname="plex"          --profile="Fedora-27-x86_64"     --interface="eth0" --mac-address="00:16:3e:03:72:d0" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4

    cobbler-exec system add --name="fedora-workstation" --hostname="fedora-workstation"  --profile="Fedora-27-x86_64"  --interface="eth0" --mac-address="52:54:00:62:d7:a8" --virt-type="kvm" --virt-file-size="50"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4
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
