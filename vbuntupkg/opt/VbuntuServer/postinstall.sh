#!/bin/bash

contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}


UBUNTU_VER=`cat /etc/issue | awk '{print $2;}'`

###############################################################################
# postinstall.sh
# This script is executed after extra package installation.
###############################################################################

###############################################################################
# change LXDM screen
mkdir -p /usr/share/backgrounds
cp -f /opt/VbuntuServer/lxdm.png /usr/share/backgrounds/default.png

###############################################################################
# LXDE enable permission for reboot, shutdown etc
echo "session required pam_systemd.so" >> /etc/pam.d/lxdm

###############################################################################
# In some network adaptor in Ubuntu 14.04 has p5p1 name instead eth0 for this...
#sed -e 's/GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 biosdevname=0"/g' /etc/default/grub > /tmp/grub
#mv /tmp/grub /etc/default/grub
#update-grub
###############################################################################
# change system files: 
# leave /var/log/message for rsyslog /etc/rsyslog.d/50-default.conf
mv -f /opt/VbuntuServer/50-default.conf /etc/rsyslog.d/50-default.conf
# change UseDNS no for sshd
mv -f /opt/VbuntuServer/sshd_config /etc/ssh/sshd_config

###############################################################################
# subversion 's config
mkdir -p /home/toor/.subversion
mv -f /opt/VbuntuServer/svn.config /home/toor/.subversion/config

###############################################################################
# 다음을 넣고 12.04에서 돌렸더니 멈춤 현상 발생
# change uid toor: 1000 => 501, gid staff: 1000 => 20 (dialout <=> staff)
# do not apply
if [[ $UBUNTU_VER == XXX ]];then
	mv -f /opt/VbuntuServer/group /opt/VbuntuServer/passwd /etc
	chown -R 501:20 /opt/VbuntuServer /home/toor
	# 다음은 14.04에서 service networking restart 안되는 문제 해결을 위하여
	mv -f /opt/VbuntuServer/networking.1310 /etc/init.d/networking
	chmod +x /etc/init.d/networking; chown root:root /etc/init.d/networking
	mv -f /opt/VbuntuServer/networking.conf.1310 /etc/init/networking.conf
else
	chown -R 1000:1000 /opt/VbuntuServer /home/toor
	# /etc/apt/sources.list 에 kr.archive.ubuntu.com 을 ftp.daum.net으로 변경
	sed -e 's/kr.archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list > /tmp/sources.list
	mv /tmp/sources.list /etc/apt/sources.list
fi

###############################################################################
# ks.cfg %post script moved here because of kickseed script is stopped during os install
python /opt/VbuntuServer/pkg-purge.py xscreensaver xscreensaver-data
echo "toor ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "VbuntuServer" > /etc/hostname
echo "127.0.0.1	VbuntuServer" >> /etc/hosts
mkdir -p /var/lib/locales/supported.d
echo "ko_KR.UTF-8 UTF-8
en_US.UTF-8 UTF-8" > /var/lib/locales/supported.d/local
locale-gen
rm -f /etc/alternatives/xinput-ko_KR
ln -s /etc/X11/xinit/xinput.d/nabi /etc/alternatives/xinput-ko_KR
echo 'LANG="ko_KR.UTF-8"' > /etc/default/locale
#sed -e "s/^black=*$/black=syslog usbmux mongodb mysql/g" /etc/lxdm/lxdm.conf > /tmp/lxdm.conf
#mv /tmp/lxdm.conf /etc/lxdm/lxdm.conf
cp -f /opt/VbuntuServer/lxdm.conf /etc/lxdm/lxdm.conf

###############################################################################
# crontab 수정
###############################################################################
echo "0 * * * * /opt/VbuntuServer/new_wallpaper" >> /var/spool/cron/crontabs/toor
# toor is not yet created !!!
chown 1000:crontab /var/spool/cron/crontabs/toor

###############################################################################
# 16.04 LTS 이상 버전 맞추기 작업
###############################################################################
#contains $UBUNTU_VER "16.04"
if [[ ! $UBUNTU_VER < "16.04" ]];then
# 1) delete wicd (network ui manager)
# lxde 대신 lxde-core ... 으로 pkgs.16.04.cfg 에 수정
# cannot delete ...
#python /opt/VbuntuServer/pkg-purge.py wicd wicd-daemon wicd-gtk python-dbus python-wicd rfkill wpasupplicant
# 2) delete clipit (lightweight GTK+ clipboard manager)
# lxde 대신 lxde-core ... 으로 pkgs.16.04.cfg 에 수정
#python /opt/VbuntuServer/pkg-purge.py clipit libxdo3 xdotool
# 3) remove home folders
rm -rf /home/toor/공개 /home/toor/문서 /home/toor/비디오 /home/toor/사진 /home/toor/음악 /home/toor/템플릿
rm -rf /home/toor/Public /home/toor/Documents /home/toor/Videos /home/toor/Pictures /home/toor/Music /home/toor/Templates
# 4) Hangul nabi
if [ ! -e /home/toor/.xinputrc ];then
	echo '
GTK_IM_MODULE="hangul2"
QT4_IM_MODULE="xim"
XMODIFIERS="@im=nabi"
' > /home/toor/.xinputrc
fi
if [ ! -e /home/toor/.config/autostart/nabi.desktop ];then
	mkdir -p /home/toor/.config/autostart
	echo '
[Desktop Entry]
Encoding=UTF-8
Name= nabi
Comment=nabi Korean Input Method
Exec=/usr/bin/nabi
Terminal=false
' > /home/toor/.config/autostart/nabi.desktop
fi

# 5) sudo ... tab completion
cp -f /opt/VbuntuServer/root.bashrc /root/.bashrc

## 6) enp0s5 => eth0 : not work (첫 설치시 grub 과 쫑이 나서 막음) 
#grep "net.ifnames=0 biosdevname=0" /etc/default/grub
#if [ $? -ne 0 ];then
#	sed -e 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 biosdevname=0"/g' /etc/default/grub > /tmp/grub.tmp
#	mv -f /tmp/grub.tmp /etc/default/grub
#fi
#grep "enp0s5" /etc/network/interfaces
#if [ $? -eq 0 ];then
#	sed -e 's/enp0s5/eth0/g' /etc/network/interfaces > /tmp/interfaces.tmp
#	mv -f /tmp/interfaces.tmp /etc/network/interfaces
#fi

# 7) LXDE panel
mv -f /home/toor/.config/lxpanel/LXDE/panels/panel.16 /home/toor/.config/lxpanel/LXDE/panels/panel

# 8) tmux.conf
mv -f /home/toor/.tmux.conf.16 /home/toor/.tmux.conf

fi

