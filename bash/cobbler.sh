#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../scripts/bash/cobbler-utils.sh

addDistros() {
	distro-add  CentOS-7.1-x86_64             /root/distro/iso/CentOS-7-x86_64-Everything-1503-01.iso   /root/distro/content/CentOS-7.1-x86_64
	distro-add  RHEL-Server-7.1-x86_64        /root/distro/iso/rhel-server-7.1-x86_64-dvd.iso           /root/distro/content/RHEL-Server-7.1-x86_64
	distro-add  Fedora-Server-22-x86_64       /root/distro/iso/Fedora-Server-DVD-x86_64-22.iso          /root/distro/content/Fedora-Server-22-x86_64

	distro-add  RHEL-Atomic-7.1-x86_64        /root/distro/iso/rhel-atomic-installer-7.1-1.x86_64.iso   /root/distro/content/RHEL-Atomic-7.1-x86_64
	distro-add  Fedora-Workstation-22-x86_64  /root/distro/iso/Fedora-Live-Workstation-x86_64-22-3.iso  /root/distro/content/Fedora-Workstation-22-x86_64
}

addRepos() {
	repo-add  CentOS-7-extras-x86_64       x86_64  http://mirror.centos.org/centos-7/7/extras/x86_64
	repo-add  CentOS-7-centosplus-x86_64   x86_64  http://mirror.centos.org/centos-7/7/centosplus/x86_64
	repo-add  CentOS-7-updates-x86_64      x86_64  http://mirror.centos.org/centos-7/7/updates/x86_64

	repo-add  Epel-7-x86_64                x86_64  http://dl.fedoraproject.org/pub/epel/7/x86_64

	repo-add  Fedora-22-everything-x86_64  x86_64  http://dl.fedoraproject.org/pub/fedora/linux/releases/22/Everything/x86_64/os
	repo-add  Fedora-22-updates-x86_64     x86_64  http://dl.fedoraproject.org/pub/fedora/linux/updates/22/x86_64
}

addProfiles() {
    CENTOS_REPOS="Epel-7-x86_64 CentOS-7-extras-x86_64 CentOS-7-centosplus-x86_64 CentOS-7-updates-x86_64"
    RHEL_REPOS="Epel-7-x86_64"
    FEDORA_REPOS="Fedora-22-everything-x86_64 Fedora-22-updates-x86_64"
    KICKSTART="/var/lib/cobbler/kickstarts/system.ks"
    ENTERPISE_KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com packages=koan,redhat-lsb"
    FEDORA_KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com p0 packages=koan operatingSystem=fedora operatingSystemVersion=22"

	profile-add  CentOS-7.1-host-x86_64  CentOS-7.1-x86_64        "${CENTOS_REPOS}"  "${KICKSTART}"  "${ENTERPISE_KSMETA_DATA}"
	profile-add  RHEL-7.1-host-x86_64    RHEL-Server-7.1-x86_64   "${RHEL_REPOS}"    "${KICKSTART}"  "${ENTERPISE_KSMETA_DATA}"
	profile-add  Fedora-22-host-x86_64   Fedora-Server-22-x86_64  "${FEDORA_REPOS}"  "${KICKSTART}"  "${FEDORA_KSMETA_DATA}"     "nogpt"
}

addSystems() {
    system-remove-all

    KSMETA_DATA="auth=-useshadow,--enablemd5,--enablenis,--nisdomain=flossware.com authconfig=--nisdomain=flossware.com packages=koan,redhat-lsb lvmDisks=sda,sdb"

    system-add centos-7.1-x86-64  CentOS-7.1-host-x86_64
    system-add rhel-7.1-x86-64    RHEL-7.1-host-x86_64
    system-add fedora-22-x86-64   Fedora-22-host-x86_64

    system-add host-1             CentOS-7.1-host-x86_64  00:14:22:2A:AF:F8  eth0  "${KSMETA_DATA}"
    system-add host-2             CentOS-7.1-host-x86_64  00:19:B9:1F:34:B6  eth0  "${KSMETA_DATA}"

    system-create-iso
}

createNetwork() {
    remove-all
    addDistros
    addRepos
    addProfiles
    addSystems
}

createNetwork
