#!/bin/bash

echo "Welcome to your custom grml!"

HASOVERLAYFS=$( mount | grep "overlay on" | echo 1 )

 # New GRML
if [ $HASOVERLAYFS ]; then
  mkdir -p /grml-custom/work
  mkdir /grml-custom/overlay
  mount -t overlay -o lowerdir=/:/lib/live/mount/medium/overlay,workdir=/grml-custom/work overlay /grml-custom/overlay

  # Since overlayfs doesn't allow remounting root path we do it for each directory
  echo Binding custom overlay…
  for P in $( cd /lib/live/mount/medium/overlay; find . -maxdepth 1 -type d -not -name ".*" | tr -d './'); do 
    echo $P
    mount --bind /grml-custom/overlay/$P /$P
    [ ! -d /$P ] && mkdir -p /$P
    echo $i; 
  done;
  echo done.

  # Old grml
else

   sudo mount -t aufs -o remount,rw,dirs=/lib/live/mount/medium/custom=ro unionfs /

fi;

grml-quickconfig

