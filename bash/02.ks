# Use text mode install
text

# Do not configure the X Window System
skipx

# Install OS instead of upgrade
install


# Setup authentication options
auth --useshadow --enablenis --nisdomain=flossware.com


# Do we poweroff, reboot, or shutdown after installation
reboot


# Firewall configuration
firewall --disabled

# Run the Setup Agent on first boot
firstboot --disable

# System keyboard
keyboard us

# System language
lang en_US

# System timezone
timezone America/New_York

# Installation logging level
logging --level=debug

# Use network installation
url --url="http://192.168.168.32/cblr/links/RHEL-7-x86_64"


# SELinux configuration
selinux --disabled


# Define root credentials
rootpw --plaintext cobbler

# Define networking
network --hostname=cloud-host-02 --bootproto=dhcp --device=eth0 


zerombr



# System bootloader configuration




# Clear our disk partions...
clearpart --all






part /boot --fstype="ext3" --size="512" --recommended


    part pv.1 --grow --ondisk=sda --size=10
    part pv.2 --grow --ondisk=sdb --size=10
    part pv.3 --grow --ondisk=sdc --size=10

volgroup VolGroup00  pv.1 pv.2 pv.3

logvol swap --fstype="swap" --name=lv_swap --vgname=VolGroup00 --recommended
logvol / --fstype="xfs" --name=lv_root --vgname=VolGroup00 --size=1024 --recommended --grow


# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
repo --name=Epel-7 --baseurl=http://dl.fedoraproject.org/pub/epel/7/x86_64 
repo --name=source-1 --baseurl=http://192.168.168.32/cobbler/ks_mirror/RHEL-7-x86_64
repo --name=source-2 --baseurl=http://192.168.168.32/cobbler/ks_mirror/RHEL-7-x86_64/addons/HighAvailability
repo --name=source-3 --baseurl=http://192.168.168.32/cobbler/ks_mirror/RHEL-7-x86_64/addons/ResilientStorage



%packages
@core
redhat-lsb
%end


%post 

/bin/dbus-uuidgen > /var/lib/dbus/machine-id





/sbin/chkconfig --add network
/sbin/chkconfig network on

/sbin/chkconfig --del NetworkManager
/sbin/chkconfig NetworkManager off

/sbin/chkconfig --add sshd
/sbin/chkconfig sshd on


curl "http://192.168.168.32/cblr/svc/op/ks/system/cloud-host-02" -o /root/cobbler.ks
curl "http://192.168.168.32/cblr/svc/op/trig/mode/post/system/cloud-host-02" -o /dev/null 
%end

