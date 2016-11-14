#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../scripts/bash/cobbler-utils.sh

addXenVms() {
    XEN_VM_KSMETA_DATA='bootloader="--location=mbr --boot-drive=xvda"'

    cobbler-exec system add --name="centos-5-xen"  --hostname="centos-xen" --profile="CentOS-5-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="centos-6-xen"  --hostname="centos-xen" --profile="CentOS-6-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="centos-7-xen"  --hostname="centos-xen" --profile="CentOS-7-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="fedora-24-xen" --hostname="fedora-xen" --profile="Fedora-24-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="rhel-7-xen"    --hostname="rhel-xen"   --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"

    cobbler-exec system add --name="centos-7-atomic-xen"  --hostname="centos-atomic-xen" --profile="CentOS-7-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="fedora-24-atomic-xen" --hostname="fedora-atomic-xen" --profile="Fedora-24-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="rhel-7-atomic-xen"    --hostname="rhel-atomic-xen"   --profile="RHEL-7-Atomic-x86_64"     --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta="${XEN_VM_KSMETA_DATA}"

    cobbler-exec system add --name="workstation"   --hostname="workstation"   --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="00:16:3e:1c:97:ac" --virt-type="xenpv" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="atomic-master" --hostname="atomic-master" --profile="RHEL-7-Atomic-x86_64" --interface="eth0"  --mac-address="00:16:3e:39:ce:5e" --virt-type="xenpv" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1 --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="db"            --hostname="db"            --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="00:16:3e:50:39:07" --virt-type="xenpv" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1 --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="pulp"          --hostname="pulp"          --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="00:16:3e:4e:fc:64" --virt-type="xenpv" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="solr"          --hostname="solr"          --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="00:16:3e:7f:38:c8" --virt-type="xenpv" --virt-file-size="100" --virt-ram="3400" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="${XEN_VM_KSMETA_DATA}"
}

addXenVms
