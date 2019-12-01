#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {

    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'
    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0'

    distro-add        CentOS-8-x86_64          /opt/iso/CentOS-8-x86_64-1905-dvd1.iso                      --ksmeta="${ENTERPISE_KSMETA_DATA}"

    distro-add        RHEL-8-x86_64            /opt/iso/rhel-8.0-x86_64-dvd.iso                           --ksmeta="${ENTERPISE_KSMETA_DATA}"

    distro-add        Fedora-31-x86_64         /opt/iso/Fedora-Server-dvd-x86_64-31-1.9.iso               --ksmeta="${FEDORA_KSMETA_DATA}"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-8-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-8-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-8-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Epel-8"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/8/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Fedora-31-everything" --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/31/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-31-updates"    --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/31/Everything/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    CENTOS_8_REPOS="Epel-8 CentOS-8-extras CentOS-8-centosplus CentOS-8-updates"

    RHEL_8_REPOS="Epel-8"

    FEDORA_REPOS="Fedora-31-everything Fedora-31-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec profile add --name="CentOS-8-x86_64"         --distro="CentOS-8-x86_64"         --repos="${CENTOS_7_REPOS}" --kickstart="${STANDARD_KICKSTART}"

    cobbler-exec profile add --name="RHEL-8-x86_64"           --distro="RHEL-8-x86_64"                                     --kickstart="${STANDARD_KICKSTART}"

    cobbler-exec profile add --name="Fedora-31-x86_64"        --distro="Fedora-31-x86_64"        --repos="${FEDORA_REPOS}" --kickstart="${STANDARD_KICKSTART}"
}

# ---------------------------------------------------------
# Add host definitions...
# ---------------------------------------------------------
addHosts() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="cloud-host-01" --hostname="cloud-host-01" --profile="RHEL-8-x86_64"   --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc" completionMethod=reboot'
    cobbler-exec system add --name="cloud-host-02" --hostname="cloud-host-02" --profile="RHEL-8-x86_64"   --interface="eth0" --mac-address="00:21:9B:32:5F:78" --virt-type="kvm"   --ksmeta='lvmDisks="sda sdb sdc" completionMethod=reboot' 

    cobbler-exec system add --name="laptop-01"     --hostname="laptop-01"     --profile="RHEL-8-x86_64"   --interface="eth0" --mac-address="00:8C:FA:2D:45:05" --virt-type="kvm"   --ksmeta='autopart="--nohome" lvmDisks="sda" completionMethod="reboot"'
}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="centos-8"  --hostname="centos-8"  --profile="CentOS-8-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="fedora-31" --hostname="fedor-31"  --profile="Fedora-31-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="rhel-8"    --hostname="rhel-8"    --profile="RHEL-8-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="centos" --hostname="centos"      --profile="CentOS-8-x86_64"  --interface="eth0" --mac-address="00:16:3e:65:f9:d9" --virt-type="kvm" --virt-file-size="25"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="rhel" --hostname="rhel"      --profile="RHEL-8-x86_64"  --interface="eth0" --mac-address="00:16:3e:29:e7:49" --virt-type="kvm" --virt-file-size="25"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0
    cobbler-exec system add --name="fedora" --hostname="fedora"      --profile="Fedora-31-x86_64"  --interface="eth0" --mac-address="52:54:00:62:d7:a8" --virt-type="kvm" --virt-file-size="25"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="jenkins-slave" --hostname="jenkins-slave"  --profile="Fedora-31-x86_64"  --interface="eth0" --mac-address="00:16:3e:6f:bf:04" --virt-type="kvm" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1

    cobbler-exec system add --name="controller" --hostname="controller"  --profile="Fedora-31-x86_64"  --interface="eth0" --mac-address="00:16:3e:7c:d0:70" --virt-type="kvm" --virt-file-size="25"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1
}

addDistros
addRepos
addProfiles

addHosts

addVms

system-create-iso
