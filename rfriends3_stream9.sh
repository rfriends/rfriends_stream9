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
setenforce 0
# タイムゾーンを東京に
timedatectl set-timezone Asia/Tokyo
# firewall
sudo firewall-cmd –permanent –zone=public –add-service=http
sudo firewall-cmd –reload
# -----------------------------------------
echo
echo RPM Fusion リポジトリを追加
echo
sudo yum -y install epel-release
sudo yum -y config-manager --set-enabled crb

#sudo yum -y install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm -y
#sudo yum -y install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y

# -----------------------------------------
optlighttpd="off"
optsamba="on"
export optlighttpd
export optsamba
#
sh centos_install.sh 2>&1 | tee centos_install.log
# -----------------------------------------
# 終了
# -----------------------------------------
echo
echo finished
# -----------------------------------------
