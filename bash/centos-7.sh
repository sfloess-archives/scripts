#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="redhat-lsb"'

    distro-add        CentOS-7-x86_64          /opt/distro/iso/CentOS-7-x86_64-DVD-1810.iso                      --ksmeta="${ENTERPISE_KSMETA_DATA}"

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-extras"      --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-centosplus"  --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-updates"     --arch=x86_64 --mirror="http://mirror.centos.org/centos-7/7/updates/x86_64"

    CENTOS_7_REPOS="Epel-7 CentOS-7-extras CentOS-7-centosplus CentOS-7-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec profile add --name="CentOS-7-x86_64"         --distro="CentOS-7-x86_64"         --repos="${CENTOS_7_REPOS}" --kickstart="${STANDARD_KICKSTART}"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="cloud-host-01" --hostname="cloud-host-01" --profile="CentOS-7-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --virt-type="xenpv" --ksmeta='lvmDisks="sda sdb" completionMethod=reboot'

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    cobbler-exec system add --name="centos-kvm"  --hostname="centos-kvm"  --profile="CentOS-7-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --kickstart="${STANDARD_KICKSTART}" --netboot-enabled=1

    cobbler-exec system add --name="centos-xen" --hostname="centos-xen" --profile="CentOS-7-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta='completionMethod=poweroff'

cobbler-exec system add --name="cobbler-kvm" --hostname="cobbler-kvm" --profile="Centos-7-x86_64" --interface="eth0"  --mac-address="00:16:3e:67:a5:62" --ksmeta='completionMethod=poweroff' --virt-type="kvm" --virt-file-size="50" --virt-ram="2048" --virt-bridge="bridge0" --virt-auto-boot=0

    cobbler-exec system add --name="cobbler-xen" --hostname="cobbler-xen" --profile="Centos-7-x86_64" --interface="eth0"  --mac-address="00:16:3e:45:41:11" --virt-type="xenpv" --virt-file-size="50" --virt-ram="2048" --virt-bridge="bridge0"