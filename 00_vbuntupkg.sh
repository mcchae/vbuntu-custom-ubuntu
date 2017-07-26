#!/bin/bash

source VERSION.sh
[ $? -ne 0 ] && exit 1

sudo apt-get update
[ $? -ne 0 ] && exit 2

rm -rf $HOME/vbuntupkg
cp -ad vbuntupkg $HOME

sudo apt-get --yes install gdebi
[ $? -ne 0 ] && exit 4

pushd $HOME
	dpkg-deb --build vbuntupkg
	[ $? -ne 0 ] && exit 7
popd

if [ ! -d apt-archives.$UBUNTU_VERSION ];then
	mkdir -p apt-archives.$UBUNTU_VERSION
fi
cp -f $HOME/vbuntupkg.deb apt-archives.$UBUNTU_VERSION
[ $? -ne 0 ] && exit 9

rm -rf $HOME/vbuntupkg

exit 0
