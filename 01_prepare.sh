#!/bin/bash
source VERSION.sh

# 1) make new working directory
sudo rm -rf $HOME/custom-iso $HOME/original-iso
mkdir $HOME/original-iso

# 2) get ubuntu iso
if [ ! -e ubuntu-$UBUNTU_VERSION-server-amd64.iso ];then
	wget http://ftp.daumkakao.com/ubuntu-releases/$UBUNTU_VERSION/ubuntu-$UBUNTU_VERSION-server-amd64.iso
fi

# 3) copy original image contents
if [ ! -e $HOME/tmp ];then
	mkdir -p $HOME/tmp
fi
cp ubuntu-$UBUNTU_VERSION-server-amd64.iso $HOME/tmp
sudo mount -o loop $HOME/tmp/ubuntu-$UBUNTU_VERSION-server-amd64.iso $HOME/original-iso
[ $? -ne 0 ] && exit 1
cp -a --no-preserve=timestamps,mode,ownership $HOME/original-iso $HOME/custom-iso
[ $? -ne 0 ] && exit 2
sudo umount $HOME/original-iso
[ $? -ne 0 ] && exit 3
sudo rmdir  $HOME/original-iso
[ $? -ne 0 ] && exit 4
chmod -R ug+w $HOME/custom-iso
[ $? -ne 0 ] && exit 5

exit 0
