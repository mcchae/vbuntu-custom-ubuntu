#!/bin/bash
source VERSION.sh

sudo apt-get install genisoimage
[ $? -ne 0 ] && exit 1
sudo mkisofs -joliet-long -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -z -iso-level 4 -c isolinux/isolinux.cat -o ./VbuntuServer-$UBUNTU_VERSION-amd64.iso $HOME/custom-iso/
[ $? -ne 0 ] && exit 2
exit 0
