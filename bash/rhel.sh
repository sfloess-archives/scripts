#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="koan redhat-lsb"'

distro-add        RHEL-5-x86_64            /root/distro/iso/rhel-server-5.11-x86_64-dvd.iso            --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-6-x86_64            /root/distro/iso/rhel-server-6.8-x86_64-dvd.iso             --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-7-x86_64            /root/distro/iso/rhel-server-7.3-x86_64-dvd.iso             --ksmeta="${ENTERPISE_KSMETA_DATA}"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
    cobbler-exec repo add --mirror-locally="0" --name="Epel-5"               --mirror="http://dl.fedoraproject.org/pub/epel/5/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-6"               --mirror="http://dl.fedoraproject.org/pub/epel/6/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-7"               --mirror="http://dl.fedoraproject.org/pub/epel/7/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    RHEL_5_REPOS="Epel-5"
    RHEL_6_REPOS="Epel-6"
    RHEL_7_REPOS="Epel-7"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec profile edit --name="RHEL-5-x86_64"           --distro="RHEL-5-x86_64"           --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_5_REPOS}"
    cobbler-exec profile edit --name="RHEL-6-x86_64"           --distro="RHEL-6-x86_64"           --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_6_REPOS}"
    cobbler-exec profile edit --name="RHEL-7-x86_64"           --distro="RHEL-7-x86_64"           --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_7_REPOS}"
}

addDistros
addRepos
addProfiles
