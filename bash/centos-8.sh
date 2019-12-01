#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'

distro-add        CentOS-8-x86_64          /opt/iso/CentOS-8-x86_64-1905-dvd1.iso                      --ksmeta="${ENTERPISE_KSMETA_DATA}"

cobbler-exec repo add --mirror-locally="0" --name="CentOS-8-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-8/8/extras/x86_64/os"
cobbler-exec repo add --mirror-locally="0" --name="CentOS-8-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-8/8/centosplus/x86_64/os"
cobbler-exec repo add --mirror-locally="0" --name="CentOS-8-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-8/8/updates/x86_64/os"

cobbler-exec repo add --mirror-locally="0" --name="Epel-8"               --arch=x86_64 --mirror="http://dl.fedoraproject.org/pub/epel/8/x86_64"

CENTOS_8_REPOS="Epel-8 CentOS-8-extras CentOS-8-centosplus CentOS-8-updates"

STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

cobbler-exec profile add --name="CentOS-8-x86_64"         --distro="CentOS-8-x86_64"         --repos="${CENTOS_8_REPOS}" --kickstart="${STANDARD_KICKSTART}"


cobbler-exec system add --name="centos-8"  --hostname="centos-8"  --profile="CentOS-8-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

cobbler-exec system add --name="centos" --hostname="centos"      --profile="CentOS-8-x86_64"  --interface="eth0" --mac-address="random" --virt-type="kvm" --virt-file-size="50"  --virt-ram="4096" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="autopart='--nohome' packages='python,libselinux-python'" --kickstart="${STANDARD_KICKSTART}" --virt-auto-boot=0

