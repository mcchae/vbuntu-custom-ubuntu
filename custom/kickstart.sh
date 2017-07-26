#!/bin/bash

sudo apt-get remove hwdata
wget ftp://mirror.ovh.net/mirrors/ftp.debian.org/debian/pool/main/h/hwdata/hwdata_0.234-1_all.deb
sudo dpkg -i  hwdata_0.234-1_all.deb
sudo apt-get install system-config-kickstart
rm -f hwdata_0.234-1_all.deb*
