#!/bin/sh
# -----------------------------------------
# Rfriends (radiko radiru録音ツール)
# 2022/03/18
# 2022/12/22 stream9
# 2024/12/16 github
# -----------------------------------------
SITE=https://github.com/rfriends/rfriends3/releases/latest/download
SCRIPT=rfriends3_latest_script.zip
dir=$(cd $(dirname $0);pwd)
user=`whoami`
HOME=/home/$user
userstr="s/rfriendsuser/${user}/g"
# -----------------------------------------
echo
echo rfriends Setup Utility Ver. 2.10
echo
echo "これは CentOS Stream 9 用です"
echo
echo "RPM Fusion リポジトリを追加しますか　(y/n) ?"
read ans
if [ "$ans" = "y" ]; then
    #
    sudo yum install epel-release
    sudo yum config-manager --set-enabled crb

    sudo yum install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm -y
    sudo yum install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y
fi
# -----------------------------------------
# ツールのインストール
# -----------------------------------------
sudo timedatectl set-timezone Asia/Tokyo
echo
echo "yum update します"
echo

sudo yum update

echo
echo php, ffmpeg, at, AtomicParsley
echo

echo "上記ツールをインストールしますか　(y/n) ?"
read ans
if [ "$ans" = "y" ]; then

	sudo yum -y install unzip php-cli php-xml php-zip php-mbstring php-json php-curl php-intl
	sudo yum -y install ffmpeg ffmpeg-devel
 
	sudo yum -y install at
 	#sudo yum -y install cronie
  
	#sudo yum -y install AtomicParsley
        #wget https://mirror.perchsecurity.com/pub/archive/fedora/linux/releases/36/Everything/x86_64/os/Packages/a/AtomicParsley-0.9.5-19.fc36.x86_64.rpm  
        sudo rpm -ivh AtomicParsley-0.9.5-19.fc36.x86_64.rpm 
	
	sudo apt -y install chromium
 
	#sudo yum -y install samba
	#sudo apt -y install lighttpd lighttpd-mod-webdav php-cgi
	#sudo yum -y install libmp4v2
	#sudo yum -y install gpac
	#sudo yum -y install ImageMagick
	#sudo yum -y install swftools

 	sudo systemctl start atd
fi

echo
echo "rfriends3をインストールしますか　(y/n) ?"
read ans
if [ "$ans" = "y" ]; then
    cd ~/
    rm -f $SCRIPT
    wget $SITE/$SCRIPT
    unzip -q -o $SCRIPT
fi
# -----------------------------------------
#echo rfriends3の実行方法
#echo
#echo cd ~/rfriends3
#echo sh rfriends3.sh
# -----------------------------------------
echo
echo configure samba
echo

#sudo mkdir -p /var/log/samba
#sudo chown root.adm /var/log/samba

#mkdir -p $HOME/smbdir/usr2/

#sudo cp -p /etc/samba/smb.conf /etc/samba/smb.conf.org
#sudo sed -e ${userstr} $dir/smb.conf.skel > $dir/smb.conf
#sudo cp -p $dir/smb.conf /etc/samba/smb.conf
#sudo chown root:root /etc/samba/smb.conf
# -----------------------------------------
echo
echo configure usrdir
echo
#mkdir -p $HOME/tmp/
#sed -e ${userstr} $dir/usrdir.ini.skel > $HOME/rfriends3/config/usrdir.ini
# -----------------------------------------
#  ビルトインサーバ
#
echo
echo rfriends3の実行方法
echo 
echo rfriends3/rf3server.sh
echo
echo 以下が表示されるので、webブラウザでアクセス
echo
echo rfriends3_server start
echo xxx.xxx.xxx.xxx:8000
echo
# -----------------------------------------
# 終了
# -----------------------------------------
echo
echo finished
# -----------------------------------------
