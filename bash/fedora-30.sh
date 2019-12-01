#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0'

    distro-add        Fedora-30-x86_64         /opt/distro/iso/Fedora-Server-dvd-x86_64-30-1.2.iso               --ksmeta="${FEDORA_KSMETA_DATA}"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-30-everything" --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/30/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-30-updates"    --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/30/Everything/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    FEDORA_REPOS="Fedora-30-everything Fedora-30-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec profile add --name="Fedora-30-x86_64"        --distro="Fedora-30-x86_64"        --repos="${FEDORA_REPOS}" --kickstart="${STANDARD_KICKSTART}"
}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="workstation" --hostname="workstation"      --profile="Fedora-30-x86_64"  --interface="eth0" --mac-address="52:54:00:62:d7:a8" --virt-type="kvm" --virt-file-size="50"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

    cobbler-exec system add --name="jenkins-slave" --hostname="jenkins-slave"  --profile="Fedora-30-x86_64"  --interface="eth0" --mac-address="00:16:3e:6f:bf:04" --virt-type="kvm" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1
}

addDistros
addRepos
addProfiles
addVms
