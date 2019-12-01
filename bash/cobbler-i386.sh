#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'

    distro-add        CentOS-7-i386          /opt/distro/iso/CentOS-7-i386-Everything-1810.iso               --ksmeta="${ENTERPISE_KSMETA_DATA}"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"
    cobbler-exec profile add --name="CentOS-7-i386"         --distro="CentOS-7-i386"         --kickstart="${STANDARD_KICKSTART}"
}

addDistros
addProfiles

