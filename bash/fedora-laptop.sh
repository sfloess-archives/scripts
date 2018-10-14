#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

cobbler-exec system remove --name="laptop"
cobbler-exec system add --name="laptop" --hostname="laptop" --profile="Fedora-27-x86_64"   --interface="eth0" --mac-address="00:8c:fa:2d:45:05" --virt-type="kvm" --ksmeta="autopart='--nohome' packages='python,libselinux-python,koan,urlgrabber'" --kickstart="${STANDARD_KICKSTART}"
#cobbler-exec system add --name="laptop" --hostname="laptop" --profile="Fedora-27-x86_64"   --interface="eth0" --mac-address="00:8c:fa:2d:45:05" --virt-type="kvm" --ksmeta='lvmDisks="sda"' --kickstart="${STANDARD_KICKSTART}"
#cobbler-exec system add --name="laptop" --hostname="laptop" --profile="Fedora-27-x86_64"   --interface="eth0" --mac-address="00:8c:fa:2d:45:05" --virt-type="kvm" --kickstart="${STANDARD_KICKSTART}"
