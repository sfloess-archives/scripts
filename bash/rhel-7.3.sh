#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

cobbler signature update

ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="koan redhat-lsb"'

distro-add        RHEL-7.3-x86_64            /root/distro/iso/rhel-server-7.3-x86_64-dvd.iso                --ksmeta="${ENTERPISE_KSMETA_DATA}"

RHEL_7_REPOS="Epel-7"

STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

cobbler-exec profile add --name="RHEL-7.3-x86_64"           --distro="RHEL-7.3-x86_64"           --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_7_REPOS}"
