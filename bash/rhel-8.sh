#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'

    distro-add RHEL-8-x86_64 /opt/distro/iso/rhel-8.0-x86_64-dvd.iso --ksmeta="${ENTERPRISE_KSMETA_DATA}"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
	echo "Nothing to add for repo"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec profile add --name="RHEL-8-x86_64" --distro="RHEL-8-x86_64" --kickstart="${STANDARD_KICKSTART}"
}

addDistros
addRepos
addProfiles
