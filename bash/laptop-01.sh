#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

#distro-add        CentOS-5-x86_64          /opt/iso/CentOS-5.11-x86_64-bin-DVD-1of2.iso               --ksmeta="${ENTERPISE_KSMETA_DATA}"
#istro-add        CentOS-6-x86_64          /opt/iso/CentOS-6.10-x86_64-bin-DVD1.iso                   --ksmeta="${ENTERPISE_KSMETA_DATA}"
#istro-add        CentOS-7-x86_64          /opt/iso/CentOS-7-x86_64-DVD-1810.iso                      --ksmeta="${ENTERPISE_KSMETA_DATA}"
#istro-add        CentOS-8-x86_64          /opt/iso/CentOS-8-x86_64-1905-dvd1.iso                      --ksmeta="${ENTERPISE_KSMETA_DATA}"

#istro-add        RHEL-5-x86_64            /opt/iso/rhel-server-5.11-x86_64-dvd.iso                   --ksmeta="${ENTERPISE_KSMETA_DATA}"
#istro-add        RHEL-6-x86_64            /opt/iso/rhel-server-6.10-x86_64-dvd.iso                   --ksmeta="${ENTERPISE_KSMETA_DATA}"
#istro-add        RHEL-7-x86_64            /opt/iso/rhel-server-7.7-x86_64-dvd.iso                    --ksmeta="${ENTERPISE_KSMETA_DATA}"
#istro-add        RHEL-8-x86_64            /opt/iso/rhel-8.0-x86_64-dvd.iso                           --ksmeta="${ENTERPISE_KSMETA_DATA}"

#istro-add        Fedora-31-x86_64         /opt/iso/Fedora-Server-dvd-x86_64-31-1.9.iso               --ksmeta="${FEDORA_KSMETA_DATA}"

cobbler system remove --name="laptop-01"

cobbler-exec system add --name="laptop-01"     --hostname="laptop-01"     --profile="RHEL-8-x86_64"   --interface="eth0" --mac-address="00:8C:FA:2D:45:05" --virt-type="kvm"   --ksmeta='autopart="--nohome" lvmDisks="sda" completionMethod="reboot"'
