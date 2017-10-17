#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

cobbler signature update

distro-add ubuntu-14-x86_64 /root/distro/iso/ubuntu-14.04.5-server-amd64.iso

cobbler-exec profile add --name="ubuntu-14-x86_64" --distro="ubuntu-14-x86_64"
