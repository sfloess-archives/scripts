#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'

distro-add-atomic CoreOS-x86_64   /opt/distro/iso/coreos_production_iso_image.iso --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel8"

RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"

cobbler-exec profile add --name="CoreOS-x86_64" --distro="CoreIS-x86_64"  --kickstart="${RHEL_ATOMIC_KICKSTART}"

cobbler-exec system add --name="coreos-kvm"  --hostname="coreosc-kvm" --profile="CoreOS-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='hostname="coreos-kvm"' --kickstart="${RHEL_ATOMIC_KICKSTART}" --netboot-enabled=1
