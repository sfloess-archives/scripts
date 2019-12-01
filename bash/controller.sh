#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

cobbler-exec system remove --name="controller"

cobbler-exec system add --name="controller" --hostname="controller"  --profile="Fedora-30-x86_64"  --interface="eth0" --mac-address="00:16:3e:7c:d0:70" --virt-type="kvm" --virt-file-size="25"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1

