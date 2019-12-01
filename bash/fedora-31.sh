#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    cobbler distro remove --name=Fedora-31-x86-64 --recursive
    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0'

    distro-add Fedora-31-x86_64 /opt/iso/Fedora-Server-dvd-x86_64-31-1.9.iso --ksmeta="${FEDORA_KSMETA_DATA}"

    exit $?
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-31-everything" --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/31/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-31-updates"    --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/31/Everything/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    cobbler profile remove --name=Fedora-31-x86_64 --recursive
    FEDORA_REPOS="Fedora-31-everything Fedora-31-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/templates/flossware_standard.ks"

    cobbler-exec profile add --name="Fedora-31-x86_64"        --distro="Fedora-31-x86_64"        --repos="${FEDORA_REPOS}" --kickstart="${STANDARD_KICKSTART}"
}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="fedora-31"    --hostname="fedora-31"    --profile="Fedora-31-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="fedora" --hostname="fedora"      --profile="Fedora-31-x86_64"  --interface="eth0" --mac-address="52:54:00:62:d7:a8" --virt-type="kvm" --virt-file-size="50"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="jenkins-slave" --hostname="jenkins-slave"  --profile="Fedora-31-x86_64"  --interface="eth0" --mac-address="00:16:3e:6f:bf:04" --virt-type="kvm" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1

    cobbler-exec system add --name="controller" --hostname="controller"  --profile="Fedora-31-x86_64"  --interface="eth0" --mac-address="00:16:3e:7c:d0:70" --virt-type="kvm" --virt-file-size="25"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1
}

#addDistros
#addRepos
#addProfiles
addVms
