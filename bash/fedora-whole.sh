#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

cobbler system remove --name=laptop
cobbler profile remove --name=Fedora-27-x86_64
cobbler distro remove --name=Fedora-27-x86_64

    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0'

    distro-add        Fedora-27-x86_64         /root/distro/iso/Fedora-Server-dvd-x86_64-27-1.6.iso           --ksmeta="${FEDORA_KSMETA_DATA}"

    cobbler-exec repo add --mirror-locally="0" --name="Fedora-27-everything" --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/27/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-27-updates"    --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/27/x86_64"

    FEDORA_REPOS="Fedora-27-everything Fedora-27-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec profile add --name="Fedora-27-x86_64"        --distro="Fedora-27-x86_64"        --repos="${FEDORA_REPOS}" --kickstart="${STANDARD_KICKSTART}"

    cobbler-exec system add --name="laptop" --hostname="laptop" --profile="Fedora-27-x86_64"   --interface="eth0" --mac-address="00:8c:fa:2d:45:05" --virt-type="kvm"
