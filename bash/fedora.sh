#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

    #cobbler signature update

    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0 packages="koan"'

    distro-add        Fedora-27-x86_64         /root/distro/iso/Fedora-Server-dvd-x86_64-27-1.6.iso           --ksmeta="${FEDORA_KSMETA_DATA}"

    cobbler-exec repo add --mirror-locally="0" --name="Fedora-27-everything" --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/27/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-27-updates"    --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/27/x86_64"

    FEDORA_REPOS="Fedora-27-everything Fedora-27-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec profile add --name="Fedora-27-x86_64"        --distro="Fedora-27-x86_64"        --repos="${FEDORA_REPOS}" --kickstart="${STANDARD_KICKSTART}"

    cobbler-exec system add --name="fedora-27-kvm" --hostname="fedora-27-kvm" --profile="Fedora-27-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-27-xen" --hostname="fedora-27-xen" --profile="Fedora-27-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"

    cobbler-exec system add --name="fedora-workstation" --hostname="fedora-workstation"  --profile="Fedora-27-x86_64"  --interface="eth0" --mac-address="52:54:00:62:d7:a8" --virt-type="kvm" --virt-file-size="50"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4

    cobbler-exec system add --name="fedora-workstation-xen" --hostname="fedora-workstation-xen"  --profile="Fedora-27-x86_64"  --interface="eth0" --mac-address="random" --virt-type="xenpv" --virt-file-size="50"  --virt-ram="3192" --virt-bridge="bridge0" --virt-cpus=4
