#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    remove-all

#    cobbler signature update
#    cobbler signature reload

    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'
    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0'

    distro-add        CentOS-5-x86_64          /opt/iso/CentOS-5.11-x86_64-bin-DVD-1of2.iso
    distro-add        CentOS-6-x86_64          /opt/iso/CentOS-6.10-x86_64-bin-DVD1.iso
    distro-add        CentOS-7-x86_64          /opt/iso/CentOS-7-x86_64-DVD-1810.iso
    distro-add        CentOS-8-x86_64          /opt/iso/CentOS-8-x86_64-1905-dvd1.iso

    distro-add        RHEL-5-x86_64            /opt/iso/rhel-server-5.11-x86_64-dvd.iso
    distro-add        RHEL-6-x86_64            /opt/iso/rhel-server-6.10-x86_64-dvd.iso
    distro-add        RHEL-7-x86_64            /opt/iso/rhel-server-7.7-x86_64-dvd.iso
    distro-add        RHEL-8-x86_64            /opt/iso/rhel-8.1-x86_64-dvd.iso

    distro-add        Fedora-31-x86_64         /opt/iso/Fedora-Server-dvd-x86_64-31-1.9.iso

    distro-add        Debian-10-x86_64         /opt/iso/debian-10.2.0-amd64-DVD-1.iso
    distro-add        Ubuntu-19-x86_64         /opt/iso/ubuntu-19.10-server-amd64.iso
    distro-add        FreeBSD-12-x86_64        /opt/iso/FreeBSD-12.0-RELEASE-amd64-dvd1.iso         --arch=x86_64

    distro-add-atomic Fedora-CoreOS-30-x86_64  /opt/iso/fedora-coreos-30.20191014.0-live.x86_64.iso --arch="x86_64" --os-version="fedora30"

    distro-add-atomic CentOS-7-Atomic-x86_64   /opt/iso/CentOS-Atomic-Host-Installer.iso --arch="x86_64" --os-version="rhel7"
    distro-add-atomic Fedora-29-Atomic-x86_64  /opt/iso/Fedora-AtomicHost-ostree-x86_64-29-20181025.1.iso --arch="x86_64" --os-version="fedora29"
    distro-add-atomic RHEL-7-Atomic-x86_64     /opt/iso/rhel-atomic-installer-7.7.0-1.x86_64.iso --arch="x86_64" --os-version="rhel7"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
    repo-remove-all

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-6/6/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-6/6/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-6/6/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-8-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-8-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-8-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Epel-5"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/5/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-6"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/6/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-7"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/7/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-8"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/8/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Fedora-31-everything" --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/31/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-31-updates"    --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/31/Everything/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    system-remove-all
    profile-remove-all
    addRepos

    CENTOS_5_REPOS="Epel-5"
    CENTOS_6_REPOS="Epel-6 CentOS-6-extras CentOS-6-centosplus CentOS-6-updates"
    CENTOS_7_REPOS="Epel-7 CentOS-7-extras CentOS-7-centosplus CentOS-7-updates"
    CENTOS_8_REPOS="Epel-8 CentOS-8-extras CentOS-8-centosplus CentOS-8-updates"

    RHEL_6_REPOS="Epel-5"
    RHEL_5_REPOS="Epel-6"
    RHEL_7_REPOS="Epel-7"
    RHEL_8_REPOS="Epel-8"

    FEDORA_REPOS="Fedora-31-everything Fedora-31-updates"

    cobbler-exec profile add --name="CentOS-5-x86_64"         --distro="CentOS-5-x86_64"         --repos="${CENTOS_5_REPOS}"
    cobbler-exec profile add --name="CentOS-6-x86_64"         --distro="CentOS-6-x86_64"         --repos="${CENTOS_6_REPOS}"
    cobbler-exec profile add --name="CentOS-7-x86_64"         --distro="CentOS-7-x86_64"         --repos="${CENTOS_7_REPOS}"
    cobbler-exec profile add --name="CentOS-8-x86_64"         --distro="CentOS-8-x86_64"         --repos="${CENTOS_7_REPOS}"

    cobbler-exec profile add --name="RHEL-5-x86_64"           --distro="RHEL-5-x86_64"           --repos="${RHEL_5_REPOS}"
    cobbler-exec profile add --name="RHEL-6-x86_64"           --distro="RHEL-6-x86_64"           --repos="${RHEL_6_REPOS}"
    cobbler-exec profile add --name="RHEL-7-x86_64"           --distro="RHEL-7-x86_64"           --repos="${RHEL_7_REPOS}"
    cobbler-exec profile add --name="RHEL-8-x86_64"           --distro="RHEL-8-x86_64"           --repos="${RHEL_8_REPOS}"

    cobbler-exec profile add --name="Fedora-31-x86_64"        --distro="Fedora-31-x86_64"        --repos="${FEDORA_REPOS}"

    cobbler-exec profile edit --name="Debian-10-x86_64" --kickstart=${STANDARD_SEED} --kopts="priority=critical locale=en_US"

    cobbler-exec profile add --name="CentOS-7-Atomic-x86_64"  --distro="CentOS-7-Atomic-x86_64"  --reps=""
    cobbler-exec profile add --name="RHEL-7-Atomic-x86_64"    --distro="RHEL-7-Atomic-x86_64"    --reps=""

    cobbler-exec profile add --name="Fedora-29-Atomic-x86_64" --distro="Fedora-29-Atomic-x86_64" --reps=""

    cobbler-exec profile add --name="Fedora-CoreOS-30-x86_64" --distro="Fedora-CoreOS-30-x86_64"

}

# ---------------------------------------------------------
# Add host definitions...
# ---------------------------------------------------------
#addHosts() {
#    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"
#STANDARD_SEED="/var/lib/cobbler/kickstarts/generic.seed"

#    cobbler-exec system add --name="cloud-host-01" --hostname="cloud-host-01" --profile="RHEL-8-x86_64"   --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc" completionMethod=reboot'
#    cobbler-exec system add --name="cloud-host-02" --hostname="cloud-host-02" --profile="RHEL-8-x86_64"   --interface="eth0" --mac-address="00:21:9B:32:5F:78" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc" completionMethod=reboot' 

#    cobbler-exec system add --name="laptop-01"     --hostname="laptop-01"     --profile="RHEL-8-x86_64"   --interface="eth0" --mac-address="00:8C:FA:2D:45:05" --virt-type="kvm"   --ksmeta='autopart="--nohome" lvmDisks="sda" completionMethod="reboot"'
#}

# ---------------------------------------------------------
# Add host definitions...
# ---------------------------------------------------------
addHosts() {
    STANDARD_SEED="/var/lib/cobbler/kickstarts/flossware_debian.seed"
    CLOUD_HOST_SEED="/var/lib/cobbler/kickstarts/flossware_cloud-host_debian.seed"

    cobbler-exec system add --name="cloud-host-01" --hostname="cloud-host-01" --profile="Debian-10-x86_64"   --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc" completionMethod=reboot priority=critical locale=en_US' --kickstart=${CLOUD_HOST_SEED}
    cobbler-exec system add --name="cloud-host-02" --hostname="cloud-host-02" --profile="Debian-10-x86_64"   --interface="eth0" --mac-address="00:21:9B:32:5F:78" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc" completionMethod=reboot priority=critical locale=en_US' --kickstart=${CLOUD_HOST_SEED}

    cobbler-exec system add --name="laptop-01"     --hostname="laptop-01"     --profile="Debian-10-x86_64"   --interface="eth0" --mac-address="00:8C:FA:2D:45:05" --virt-type="kvm"   --ksmeta='completionMethod="reboot"' --kickstart=${STANDARD_SEED}
}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"
    STANDARD_SEED="/var/lib/cobbler/kickstarts/flossware_debian.seed"

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"

    cobbler-exec system add --name="centos-5"  --hostname="centos-5"  --profile="CentOS-5-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="centos-6"  --hostname="centos-6"  --profile="CentOS-6-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="centos-7"  --hostname="centos-7"  --profile="CentOS-7-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="centos-8"  --hostname="centos-8"  --profile="CentOS-8-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="fedora-31"    --hostname="fedora-31"    --profile="Fedora-31-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="rhel-5"    --hostname="rhel-5"    --profile="RHEL-5-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="rhel-6"    --hostname="rhel-6"    --profile="RHEL-6-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="rhel-7"    --hostname="rhel-7"    --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="rhel-8"    --hostname="rhel-8"    --profile="RHEL-8-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="centos-7-atomic"  --hostname="centos-7-atomic" --profile="CentOS-7-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="centos-7-atomic"' --kickstart="${CENTOS_ATOMIC_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="rhel-7-atomic"    --hostname="rhel-7-atomic"   --profile="RHEL-7-Atomic-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='hostname="rhel-7-atomic"' --kickstart="${RHEL_ATOMIC_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="fedora-29-atomic"  --hostname="fedora-29-atomic" --profile="Fedora-29-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="3400" --virt-bridge="bridge0" --ksmeta='clearpart="none --initlabel" hostname="fedora-29-atomic-kvm"' --virt-auto-boot=0
    cobbler-exec system add --name="fedora-coreos-30"  --hostname="fedora-coreos-30" --profile="Fedora-CoreOS-30-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='clearpart="none --initlabel" hostname="fedora-coreos-30"' --virt-auto-boot=0

    cobbler-exec system add --name="centos" --hostname="centos"      --profile="CentOS-8-x86_64"  --interface="eth0" --mac-address="00:16:3e:65:f9:d9" --virt-type="kvm" --virt-file-size="25"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="rhel" --hostname="rhel"      --profile="RHEL-8-x86_64"  --interface="eth0" --mac-address="00:16:3e:29:e7:49" --virt-type="kvm" --virt-file-size="25"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="fedora" --hostname="fedora"      --profile="Fedora-31-x86_64"  --interface="eth0" --mac-address="52:54:00:62:d7:a8" --virt-type="kvm" --virt-file-size="25"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="debian" --hostname="debian"      --profile="Debian-10-x86_64"  --interface="eth0" --mac-address="random" --virt-type="kvm" --virt-file-size="25"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="" --kickstart="${STANDARD_SEED}" --virt-auto-boot=0 --kopts="priority=critical locale=en_US"

    cobbler-exec system add --name="jenkins-slave" --hostname="jenkins-slave"  --profile="Fedora-31-x86_64"  --interface="eth0" --mac-address="00:16:3e:6f:bf:04" --virt-type="kvm" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1

    cobbler-exec system add --name="controller" --hostname="controller"  --profile="Fedora-31-x86_64"  --interface="eth0" --mac-address="00:16:3e:7c:d0:70" --virt-type="kvm" --virt-file-size="25"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1
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

