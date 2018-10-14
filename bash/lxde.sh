. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

cobbler-exec system  remove --name=host-1
cobbler-exec profile remove --name=Fedora-27-LXDE-LIVE-x86_64
cobbler-exec distro  remove --name=Fedora-27-LXDE-LIVE-x86_64

distro-add-live Fedora-27-LXDE-Live-x86_64  /root/distro/iso/Fedora-LXDE-Live-x86_64-27-1.6.iso --arch="x86_64" --os-version="fedora27"

FEDORA_REPOS="Fedora-27-everything Fedora-27-updates"
STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

cobbler-exec profile add --name="Fedora-27-LXDE-Live-x86_64"        --distro="Fedora-27-x86_64"        --repos="${FEDORA_REPOS}" --kickstart="${STANDARD_KICKSTART}"

cobbler-exec system  add --name="host-1" --hostname="host-1" --profile="Fedora-27-LXDE-Live-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --ksmeta='lvmDisks="sda sdb"' --kickstart="${STANDARD_KICKSTART}"



