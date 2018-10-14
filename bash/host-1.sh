. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

cobbler-exec system remove --name="host-1"
cobbler-exec system add --name="host-1" --hostname="host-1" --profile="Fedora-27-x86_64" --interface="eth0" --mac-address="00:14:22:2A:AF:F8" --ksmeta='lvmDisks="sda sdb"' --kickstart="${STANDARD_KICKSTART}"
