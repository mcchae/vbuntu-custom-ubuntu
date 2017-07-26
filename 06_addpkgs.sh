#!/bin/bash
source VERSION.sh

# 알림: 설치에 필요한 Ubuntu 패키지 등은
# custom 폴더에 pkgs.cfg 아래에 패키지 명을 한줄씩 추가합니다.
# 예)
# openssh-server

cat custom/pkgs.$UBUNTU_VERSION.cfg >> $HOME/custom-iso/isolinux/ks-custom.cfg
