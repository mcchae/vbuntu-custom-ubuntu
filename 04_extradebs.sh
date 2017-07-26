#!/bin/bash

# 기본적인 Ubuntu 서버 버전에서 필요한
# extra 패키지 들을 설치한 서버라고 치고
# 해당 서버에서 기타 패키지를 ISO에 넣는 작업

source VERSION.sh

#rm -rf extradebs
#mkdir extradebs
#cp -f /var/cache/apt/archives/*.deb extradebs

# 위의 extradebs는 VbuntuServer에서 바로 설치하였을 때는 존재하지 않음
# 따라서 개별 필요 패키지를 apt-archives.$UBUNTU_VER 폴더에 미리 보관하도록 함
# build all packages
echo "builing all packages..."
for pkg in $(sed -n -e '/^[a-zA-Z]/p' custom/pkgs.$UBUNTU_VERSION.cfg | grep -v vbuntupkg);do
        sudo apt-get -y install $pkg
done
cp -f /var/cache/apt/archives/*.deb apt-archives.$UBUNTU_VERSION

mkdir -p $HOME/custom-iso/dists/stable/extras/binary-amd64
mkdir -p $HOME/custom-iso/pool/extras/
#cp ./extradebs/*.deb $HOME/custom-iso/pool/extras/
cp ./apt-archives.$UBUNTU_VERSION/*.deb $HOME/custom-iso/pool/extras/

pushd $HOME/custom-iso
  apt-ftparchive packages ./pool/extras/ > $HOME/tmp/Packages
  mv $HOME/tmp/Packages dists/stable/extras/binary-amd64/Packages
  gzip ./dists/stable/extras/binary-amd64/Packages
popd

#rm -rf extradebs
exit 0





#mkdir -p $HOME/custom-iso/dists/stable/extras/binary-amd64
mkdir -p $HOME/custom-iso/pool/extras/
#cp ./apt-archives.$UBUNTU_VERSION/*.deb $HOME/custom-iso/pool/extras/
cp ./apt-archives.$UBUNTU_VERSION/*.deb $HOME/custom-iso/pool/extras/

# gpg key
gpg --list-keys | egrep "^uid"
if [ $? -ne 0 ];then
	echo "Generate for this iso image signing"
	gpg --gen-key
fi

egrep "^deb-src" /etc/apt/sources.list
if [ $? -ne 0 ];then
	sed -e 's/^# deb-src/deb-src/g' /etc/apt/sources.list > /tmp/foo.list
	sudo mv /tmp/foo.list /etc/apt/sources.list
	sudo apt-get update
fi

sudo apt-get install fakeroot
mkdir -p build_tmp
pushd build_tmp
	apt-get source ubuntu-keyring
	cd ubuntu-keyring-*/keyrings
	gpg --import < ubuntu-archive-keyring.gpg
	MYKEYID=$(gpg --list-keys | grep "^pub" | head -n 1 | awk '{print $2}' | awk -F / '{print $2}')
	gpg --export FBB75451 437D05B5 C0B21F32 EFE21092 $MYKEYID > ubuntu-archive-keyring.gpg
	cd ..
	dpkg-buildpackage -rfakeroot -m"Moonchang Chae <mcchae@gmail.com>" -k${MYKEYID}
	cd ..
	cp ubuntu-keyring*.deb $HOME/custom-iso/pool/extras/
popd

exit 0

pushd $HOME/custom-iso
  apt-ftparchive packages ./pool/extras/ > $HOME/tmp/Packages
  mv $HOME/tmp/Packages dists/stable/extras/binary-amd64/Packages
  gzip ./dists/stable/extras/binary-amd64/Packages
popd
