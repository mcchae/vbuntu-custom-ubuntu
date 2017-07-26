# for Ubuntu 16.04

sudo apt-get install openssh-server build-essential xrdp galculator gpicview leafpad lxappearance lxappearance-obconf lxde-core lxde-icon-theme lxinput lxrandr lxsession-edit lxterminal lxde-common xarchiver evince-gtk lxshortcut openbox xserver-xorg lxdm fonts-nanum fonts-nanum-coding nabi im-config zenity firefox isc-dhcp-client subversion vim gdebi lvm2 python-dev python-pip cpuid

# oneday LXDE => LXQT
sudo apt-get install openssh-server build-essential xrdp lxqt xserver-xorg lxdm fonts-nanum fonts-nanum-coding nabi im-config zenity firefox isc-dhcp-client subversion vim gdebi lvm2 python-dev python-pip cpuid


# 1) delete wicd (network ui manager)
$ sudo apt-get purge wicd wicd-daemon wicd-gtk python-dbus python-wicd rfkill wpasupplicant
# 2) delete clipit (lightweight GTK+ clipboard manager)
$ sudo apt-get purge clipit libxdo3 xdotool
# 3) remove 
$ cd ~
$ rm -rf 공개 문서 비디오 사진 음악 템플릿
$ rm -rf Public Documents Videos Pictures Music Templates

# 4) Hangul nabi
$ cat ~/.xinputrc
GTK_IM_MODULE="hangul2"
QT4_IM_MODULE="xim"
XMODIFIERS="@im=nabi"

$ cat ~/.config/autostart/nabi.desktop 
[Desktop Entry]
Encoding=UTF-8
Name= nabi
Comment=nabi Korean Input Method
Exec=/usr/bin/nabi
Terminal=false

# 5) 우측하단 shutdown 아이콘 에러
$ sudo apt-get update
$ sudo apt-get install lxsession-logout

# 6) enp0s5 => eth0
http://mcchae.egloos.com/11177181

$ vi /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 biosdevname=0"
$ sudo update-grub

$ cat /etc/network/interfaces
# The primary network interface
#auto enp0s5
#iface enp0s5 inet dhcp
auto eth0
iface eth0 inet dhcp
# This is an autoconfigured IPv6 interface
#iface enp0s5 inet6 auto


