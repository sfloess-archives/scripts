#!/bin/bash

set -e

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'

distro-add        RHEL-7-x86_64            /opt/distro/iso/rhel-server-7.7-x86_64-dvd.iso                    --ksmeta="${ENTERPISE_KSMETA_DATA}"

cobbler-exec repo add --mirror-locally="0" --name="Epel-7"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/7/x86_64"

RHEL_7_REPOS="Epel-7"

STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

cobbler-exec profile add --name="RHEL-7-x86_64"           --distro="RHEL-7-x86_64"           --repos="${RHEL_7_REPOS}" --kickstart="${STANDARD_KICKSTART}"

cobbler-exec system add --name="rhel-7"    --hostname="rhel-7"    --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

