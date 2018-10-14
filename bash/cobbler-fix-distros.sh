#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

for aDistro in `cobbler distro list`
do
	cobbler-exec distro edit --name="${aDistro}" --in-place --ksmeta="tree=http://@@server@@/cblr/links/${aDistro}/"
	cobbler-exec distro edit --name="${aDistro}" --in-place --ksmeta="tree=http://@@server@@/cobbler/links/${aDistro}/"
done

