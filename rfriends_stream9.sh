#!/bin/sh
# -----------------------------------------
# Rfriends (radiko radiru録音ツール)
# 1.0 2022/03/18
# 1.1 2022/12/22 stream9
# 2.1 2024/12/16 github
# 2.2 2025/01/04 fix
ver=2.2
# -----------------------------------------
SITE=https://github.com/rfriends/rfriends3/releases/latest/download
SCRIPT=rfriends3_latest_script.zip
dir=$(cd $(dirname $0);pwd)
user=`whoami`
HOME=/home/$user
userstr="s/rfriendsuser/${user}/g"
# -----------------------------------------
echo
echo rfriends Setup Utility CentOS Stream 9 $ver
echo
# enforceをPermissiveに設定
sudo setenforce 0
# タイムゾーンを東京に
timedatectl set-timezone Asia/Tokyo
# -----------------------------------------
echo
echo RPM Fusion リポジトリを追加
echo
sudo yum -y install epel-release
sudo yum -y config-manager --set-enabled crb

#sudo yum -y install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm -y
#sudo yum -y install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y
# -----------------------------------------
optlighttpd="on"
optsamba="on"
export optlighttpd
export optsamba
#
sh centos_install.sh 2>&1 | tee centos_install.log
# -----------------------------------------
# selinux disabled
grep "^SELINUX=enforcing" /etc/selinux/config> /dev/null
if [ $? = 0 ]; then
  echo "現在、SELinux が有効(enforcing)に設定されています。"
	read -p "無効相当(Permissive)に変更しますか？ (y/N) " ans
	case "$ans" in
  		"y" | "Y" )
			sudo sed -i "/^SELINUX=enforcing/c SELINUX=Permissive" /etc/selinux/config
			echo "変更しました。"
			echo "再起動してください。"
			echo 
    			;;
  		* )
			echo 
    			;;
	esac
fi
# -----------------------------------------
# 終了
# -----------------------------------------
echo
echo finished
# -----------------------------------------
