#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

distro-add-atomic Fedora-CoreOS-30-x86_64  /opt/iso/fedora-coreos-30.20191014.0-live.x86_64.iso --arch="x86_64" --os-version="fedora30"

cobbler-exec profile add --name="Fedora-CoreOS-30-x86_64" --distro="Fedora-CoreOS-30-x86_64"
