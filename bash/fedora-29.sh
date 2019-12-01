#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0'

    distro-add        Fedora-29-x86_64         /opt/distro/iso/Fedora-Server-dvd-x86_64-29-1.2.iso               --ksmeta="${FEDORA_KSMETA_DATA}"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-29-everything" --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/29/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-29-updates"    --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/29/Everything/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    FEDORA_REPOS="Fedora-29-everything Fedora-29-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec profile add --name="Fedora-29-x86_64"        --distro="Fedora-29-x86_64"        --repos="${FEDORA_REPOS}" --kickstart="${STANDARD_KICKSTART}"
}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="fedora-kvm" --hostname="fedora-kvm" --profile="Fedora-29-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1

    cobbler-exec system add --name="fedora-xen" --hostname="fedora-xen" --profile="Fedora-29-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='completionMethod=poweroff' --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1

    cobbler-exec system add --name="fedora-workstation" --hostname="fedora-workstation"  --profile="Fedora-29-x86_64"  --interface="eth0" --mac-address="52:54:00:62:d7:a8" --virt-type="kvm" --virt-file-size="50"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1

    cobbler-exec system add --name="fedora-workstation-xen" --hostname="fedora-workstation-xen"  --profile="Fedora-29-x86_64"  --interface="eth0" --mac-address="00:16:3e:4f:0c:d1" --virt-type="xen" --virt-file-size="50"  --virt-ram="3400" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1
}

addDistros
addRepos
addProfiles
addVms
