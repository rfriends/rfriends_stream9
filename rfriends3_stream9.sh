#!/bin/sh
# -----------------------------------------
# Rfriends (radiko radiru録音ツール)
# 2022/03/18
# 2022/12/22 stream9
# 2024/12/16 github
# -----------------------------------------
SITE=https://github.com/rfriends/rfriends3/releases/latest/download
SCRIPT=rfriends3_latest_script.zip
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

	sudo yum -y install unzip

	sudo yum -y install php-cli
	sudo yum -y install php-xml
	sudo yum -y install php-zip
	sudo yum -y install php-mbstring
	sudo yum -y install php-json

	sudo yum -y install ffmpeg ffmpeg-devel
	sudo yum -y install at
    sudo systemctl start atd
    #sudo yum -y install cronie

	#sudo yum -y install AtomicParsley
        #wget https://mirror.perchsecurity.com/pub/archive/fedora/linux/releases/36/Everything/x86_64/os/Packages/a/AtomicParsley-0.9.5-19.fc36.x86_64.rpm  
        sudo rpm -ivh AtomicParsley-0.9.5-19.fc36.x86_64.rpm 

	#sudo yum -y install libmp4v2
	#sudo yum -y install gpac
	#sudo yum -y install ImageMagick
	#sudo yum -y install swftools
	#sudo yum -y install curl
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
echo rfriends3の実行方法(ビルトインサーバ)
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
