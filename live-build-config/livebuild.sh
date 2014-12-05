#!/bin/bash



##### Getting Ready
#apt-get -y -qq install live-build cdebootstrap git kali-archive-keyring
#apt-get -y remove libdebian-installer4
#apt-get -y install libdebian-installer4

killall apache2
killall postgres
service apache2 stop
service postgresql stop
service metasploit stop


##### Configuring the Kali ISO Build
#--- Remove GNOME 3
#sed -i 's/^gnome/#gnome/g' config/package-lists/kali.list.chroot
#--- Install XFCE
#grep 'xfce4' config/package-lists/kali.list.chroot -B1 | grep -q -v '*** XFCE DESKTOP ***\|xfce4' || echo -e '\nxfce4\nnetwork-manager-gnome\nnetwork-manager' >> config/package-lists/kali.list.chroot


##### Building the ISO
#--- Allow building x64 on x86
#dpkg --add-architecture amd64
#apt-get update
#--- Setup caching (Enable if you wish todo a lot of custom ISOs)
apt-get -y -qq install apt-cacher-ng
service apt-cacher-ng start
export http_proxy=http://localhost:3142/
#--- Remove PAE from kernel
#sed -i 's/686-pae/486/g' auto/config
#lb clean
#--- Set architecture
#lb config --architecture amd64   # x64
mv cache/packages.chroot ../
lb clean --purge
mkdir cache
mv ../packages.chroot cache
dpkg --add-architecture amd64
lb config --architecture amd64 --mirror-binary http://repo.kali.org/kali --mirror-binary-security http://security.kali.org/kali-security --apt-options "--force-yes --yes"
lb build


##### Post Build
#--- Move file somewhere that will 'last'
mv -f binary.hybrid.iso ~/custom.kali.iso
#--- Show it
ls -lh ~/custom.kali.iso
#--- Create checksums
md5sum ~/custom.kali.iso
sha1sum ~/custom.kali.iso
