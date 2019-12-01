#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

cobbler-exec system remove --name="cobbler-kvm"

cobbler-exec system add --name="cobbler-kvm" --hostname="cobbler-kvm" --profile="Centos-7-x86_64" --interface="eth0"  --mac-address="00:16:3e:67:a5:62" --ksmeta='completionMethod=poweroff' --virt-type="kvm" --virt-file-size="50" --virt-ram="2048" --virt-bridge="bridge0" --virt-auto-boot=0

