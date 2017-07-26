#!/bin/bash

source VERSION.sh
# 참고! : 만약 ks.cfg를 직접 생성하려면
# custom 폴더에서 kickstart.sh 를 수행하여 system-config-kickstart 패키지를 설치한 다음
# ksconfig ks.cfg
# 명령을 수행합니다

#cp custom/ks.cfg $HOME/custom-iso/isolinux/ks-custom.cfg

# 우분투 12, 14에서 각각의 ksconfig로 만든 것의 사용자 암호화가 틀려 문제 발생하여
# 다음과 같이 수정 : mcchae 20150805
cp custom/ks_dhcp.$UBUNTU_VERSION.cfg $HOME/custom-iso/isolinux/ks-custom.cfg

