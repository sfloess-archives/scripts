# This kickstart file should only be used with EL > 5 and/or Fedora > 7.
# For older versions please use the sample.ks kickstart file.

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=http://192.168.168.32/cblr/links/CentOS-7-x86_64
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
repo --name=source-1 --baseurl=http://192.168.168.32/cobbler/ks_mirror/CentOS-7-x86_64

# Network information
# Using "new" style networking config, by matching networking information to the physical interface's 
# MAC-address
%include /tmp/pre_install_network_config

# Reboot after installation
reboot

#Root password
rootpw --iscrypted $1$mF86/UHC$WvcIcX2t6crBz2onWxyac.
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone  America/New_York
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
autopart

%pre
set -x -v
exec 1>/tmp/ks-pre.log 2>&1

# Once root's homedir is there, copy over the log.
while : ; do
    sleep 10
    if [ -d /mnt/sysimage/root ]; then
        cp /tmp/ks-pre.log /mnt/sysimage/root/
        logger "Copied %pre section log to system"
        break
    fi
done &


curl "http://192.168.168.32/cblr/svc/op/trig/mode/pre/system/cloud-host-01" -o /dev/null
# Start pre_install_network_config generated code
# generic functions to be used later for discovering NICs
mac_exists() {
  [ -z "$1" ] && return 1

  if which ip 2>/dev/null >/dev/null; then
    ip -o link | grep -i "$1" 2>/dev/null >/dev/null
    return $?
  elif which esxcfg-nics 2>/dev/null >/dev/null; then
    esxcfg-nics -l | grep -i "$1" 2>/dev/null >/dev/null
    return $?
  else
    ifconfig -a | grep -i "$1" 2>/dev/null >/dev/null
    return $?
  fi
}
get_ifname() {
  if which ip 2>/dev/null >/dev/null; then
    IFNAME=$(ip -o link | grep -i "$1" | sed -e 's/^[0-9]*: //' -e 's/:.*//')
  elif which esxcfg-nics 2>/dev/null >/dev/null; then
    IFNAME=$(esxcfg-nics -l | grep -i "$1" | cut -d " " -f 1)
  else
    IFNAME=$(ifconfig -a | grep -i "$1" | cut -d " " -f 1)
    if [ -z $IFNAME ]; then
      IFNAME=$(ifconfig -a | grep -i -B 2 "$1" | sed -n '/flags/s/:.*$//p')
    fi
  fi
}

# Start of code to match cobbler system interfaces to physical interfaces by their mac addresses
#  Start eth0
# Configuring eth0 (00:14:22:2A:AF:F8)
if mac_exists 00:14:22:2A:AF:F8
then
  get_ifname 00:14:22:2A:AF:F8
  echo "network --device=$IFNAME --bootproto=dhcp --hostname=cloud-host-01" >> /tmp/pre_install_network_config
fi
# End pre_install_network_config generated code

# Enable installation monitoring

%end

%packages


%end

%post --nochroot
set -x -v
exec 1>/mnt/sysimage/root/ks-post-nochroot.log 2>&1

%end

%post
set -x -v
exec 1>/root/ks-post.log 2>&1

# Start yum configuration
curl "http://192.168.168.32/cblr/svc/op/yum/system/cloud-host-01" --output /etc/yum.repos.d/cobbler-config.repo

# End yum configuration



# Start post_install_network_config generated code

# create a working directory for interface scripts
mkdir /etc/sysconfig/network-scripts/cobbler
cp /etc/sysconfig/network-scripts/ifcfg-lo /etc/sysconfig/network-scripts/cobbler/

# set the hostname in the network configuration file
grep -v HOSTNAME /etc/sysconfig/network > /etc/sysconfig/network.cobbler
echo "HOSTNAME=cloud-host-01" >> /etc/sysconfig/network.cobbler
rm -f /etc/sysconfig/network
mv /etc/sysconfig/network.cobbler /etc/sysconfig/network

# Also set the hostname now, some applications require it
# (e.g.: if we're connecting to Puppet before a reboot).
/bin/hostname cloud-host-01

# Start configuration for eth0
echo "DEVICE=eth0" > /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
echo "HWADDR=00:14:22:2A:AF:F8" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
IFNAME=$(ip -o link | grep -i '00:14:22:2A:AF:F8' | sed -e 's/^[0-9]*: //' -e 's/:.*//')
if [ -f "/etc/modprobe.conf" ] && [ $IFNAME ]; then
    grep $IFNAME /etc/modprobe.conf | sed "s/$IFNAME/eth0/" >> /etc/modprobe.conf.cobbler
    grep -v $IFNAME /etc/modprobe.conf >> /etc/modprobe.conf.new
    rm -f /etc/modprobe.conf
    mv /etc/modprobe.conf.new /etc/modprobe.conf
fi
echo "TYPE=Ethernet" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
echo "BOOTPROTO=dhcp" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
# End configuration for eth0

sed -i 's/ONBOOT=yes/ONBOOT=no/g' /etc/sysconfig/network-scripts/ifcfg-eth*

rm -f /etc/sysconfig/network-scripts/ifcfg-eth0
mv /etc/sysconfig/network-scripts/cobbler/* /etc/sysconfig/network-scripts/
rm -r /etc/sysconfig/network-scripts/cobbler
echo "options bonding max_bonds=0" >> /etc/modprobe.d/bonding.conf
cat /etc/modprobe.d/bonding.conf.cobbler >> /etc/modprobe.d/bonding.conf
rm -f /etc/modprobe.d/bonding.conf.cobbler
# End post_install_network_config generated code




# Start download cobbler managed config files (if applicable)
# End download cobbler managed config files (if applicable)

# Start koan environment setup
echo "export COBBLER_SERVER=192.168.168.32" > /etc/profile.d/cobbler.sh
echo "setenv COBBLER_SERVER 192.168.168.32" > /etc/profile.d/cobbler.csh
# End koan environment setup

# begin Red Hat management server registration
# not configured to register to any Red Hat management server (ok)
# end Red Hat management server registration

# Begin cobbler registration
# skipping for system-based installation
# End cobbler registration

# Enable post-install boot notification

# Start final steps

curl "http://192.168.168.32/cblr/svc/op/ks/system/cloud-host-01" -o /root/cobbler.ks
curl "http://192.168.168.32/cblr/svc/op/trig/mode/post/system/cloud-host-01" -o /dev/null
# End final steps
%end

