#!/bin/bash -x

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"
    RHEL_7_REPOS="Epel-7"

distro-add-rhev   RHEVH-7-x86_64           /root/distro/iso/RHVH-4.0-20161018.0-RHVH-x86_64-dvd1.iso   --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7" --breed="redhat"
cobbler-exec profile add --name="RHEVH-7-x86_64"          --distro="RHEVH-7-x86_64"          --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_7_REPOS}"
