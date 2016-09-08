#!/bin/bash

# Using aufs

TMP="grml-tmp"
ISO="grml64-full_testing_latest.iso"
BASENAME=$( basename $ISO .iso )

# uses
sudo apt-get install grml2usb aufstools

mkdir -p $TMP
mkdir $TMP/grml-custom-diff
mkdir $TMP/grml-custom-overlay
mkdir $TMP/grml-iso
mkdir $TMP/grml-rootfs

mkdir -p grml-custom/scripts
mkdir -p grml-custom/overlay

touch grml-custom/scripts/grml-custom.sh
chown root:root -R grml-custom/scripts
chmod 0755 -R grml-custom/scripts/grml-custom.sh

mkdir -p grml-custom/overlayecho $
mkdir -p grml-import 

sudo mount -o loop,ro grml-iso/$ISO $TMP/grml-iso
SQUASHIMAGE=$( find $TMP/grml-iso/live -name *.squashfs )
sudo mount -t squashfs $SQUASHIMAGE $TMP/grml-rootfs
sudo mount -t aufs -o dirs=grml-custom-diff=rw:$TMP/grml-rootfs=ro unionfs $TMP/grml-custom-overlay
sudo mount --bind /sys $TMP/grml-custom-overlay/sys
sudo mount --bind /proc $TMP/grml-custom-overlay/proc 
mkdir $TMP/grml-custom-overlay/grml-custom-import
sudo mount --bind grml-import $TMP/grml-custom-overlay/grml-custom-import

# Now enter chroot
sudo chroot $TMP/grml-custom-overlay /bin/bash

umount $TMP/grml-custom-overlay/grml-custom-import
umount $TMP/grml-custom-overlay/proc 
umount $TMP/grml-custom-overlay/sys
umount $TMP/grml-custom-overlay
umount $TMP/grml-rootfs
umount $TMP/grml-iso

##
# Configure SSH
# mkdir --parent root/.ssh
# mkdir --parent home/grml/.ssh
# cp /path/to/id_rsa.pub root/.ssh/authorized_keys
# cp /path/to/id_rsa.pub home/grml/.ssh/authorized_keys
# chmod 0700 root/.ssh
# chmod 0700 home/grml/.ssh
# chown -R 1000:1000 home/grml
 
##
# Startup Scripts

 
##
# create overlay archive
sudo tar -C diff --numeric-owner -j -cv -f  overlay/config.tbz .


##
# create new iso

# use no framebuffer nofb
# start lvm
# configure for german keyboard

rsync -avz -R grml-custom-diff/* grml-custom/overlay/
rm -fr grml-custom/overlay/grml-custom-import
rm -fr grml-custom/overlay/tmp
sudo grml2iso -f -b "nofb lang=de gmt lvm startup=/lib/live/mount/medium/scripts/grml-custom.sh" -c grml-custom -o custom-grml.iso grml-iso/$ISO


