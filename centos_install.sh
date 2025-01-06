#!/bin/bash
# =========================================
# install rfriends for centos
# =========================================
# 1.0 2025/01/04 github
ver=1.0
# -----------------------------------------
echo
echo rfriends3 for centos $ver
echo `date`
echo
# もしdnfが使えないときは、dnf=yum
dnf=dnf
# -----------------------------------------
sys=`pgrep -o systemd`
if [ $? -ne 0 ]; then
sys=0
fi
#
if [ -z "$optlighttpd" ]; then
  optlighttpd="on"
fi
if [ -z "$optsamba" ]; then
  optsamba="on"
fi
if [ "$optlighttpd" != "on" ]; then
  optlighttpd="off"
fi
if [ "$optsamba" != "on" ]; then
  optsamba="off"
fi
#
dir=$(cd $(dirname $0);pwd)
user=`whoami`
if [ -z $HOME ]; then
  homedir=`sh -c 'cd && pwd'`
else
  homedir=$HOME
fi
#
SITE=https://github.com/rfriends/rfriends3/releases/latest/download
SCRIPT=rfriends3_latest_script.zip
# =========================================
echo
echo install tools
echo
# =========================================
sudo $dnf update -y

sudo $dnf -y install p7zip net-tools
sudo $dnf -y install php-cli php-xml php-zip php-mbstring php-json php-curl php-intl 
sudo $dnf -y install ffmpeg-free

#sudo $dnf -y install AtomicParsley
#wget https://mirror.perchsecurity.com/pub/archive/fedora/linux/releases/36/Everything/x86_64/os/Packages/a/AtomicParsley-0.9.5-19.fc36.x86_64.rpm  
sudo rpm -ivh AtomicParsley-0.9.5-19.fc36.x86_64.rpm 

sudo $dnf -y install chromium
sudo $dnf -y install openssh-server

sudo $dnf -y install dnsutils unzip nano vim tzdata at cronie wget curl 
# -----------------------------------------
# .vimrcを設定する
# -----------------------------------------
cd $homedir
mv -n .vimrc .vimrc.org
cat <<EOF > .vimrc
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac
EOF
chmod 644 .vimrc
# =========================================
echo
echo install rfriends3
echo
# =========================================
cd $homedir
rm -f $SCRIPT
wget $SITE/$SCRIPT
unzip -q -o $SCRIPT

mkdir -p $homedir/tmp/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/rfriends3/usr/"
tmpdir = "$homedir/tmp/"
EOF
# -----------------------------------------
# systemd or service
# -----------------------------------------
if [ $sys -eq 1 ]; then
  sudo systemctl enable atd
  sudo systemctl enable crond
else 
  sudo service atd restart
  sudo service cron restart
fi
# -----------------------------------------
echo
echo install samba
echo
# -----------------------------------------
echo samba $optsamba
if [ $optsamba = "on" ]; then
sudo $dnf -y install samba
sudo mkdir -p /var/log/samba
sudo chown root:adm /var/log/samba

sudo cp -p /etc/samba/smb.conf /etc/samba/smb.conf.org
sed -e s%rfriendshomedir%$homedir%g $dir/smb.conf.skel > $dir/smb.conf
sed -i s%rfriendsuser%$user%g $dir/smb.conf
sudo cp -p $dir/smb.conf /etc/samba/smb.conf
sudo chown root:root /etc/samba/smb.conf

mkdir -p $homedir/smbdir/usr2/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/smbdir/usr2/"
tmpdir = "$homedir/tmp/"
EOF

if [ $sys -eq 1 ]; then
  sudo systemctl enable smb
  sudo systemctl restart smb
else 
  sudo service smbd restart
fi
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd
if [ $optlighttpd = "on" ]; then
sudo $dnf -y install lighttpd php-cgi
cd $dir
#
# lighttpd
sudo cp -p /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.org
sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel > lighttpd.conf
sed -i s%rfriendsuser%$user%g lighttpd.conf
sudo cp -p lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo chown root:root /etc/lighttpd/lighttpd.conf
#
# modules
sudo cp -p /etc/lighttpd/modules.conf /etc/lighttpd/modules.conf.org
#sed -e s%rfriendshomedir%$homedir%g modules.conf.skel > modules.conf
#sed -i s%rfriendsuser%$user%g modules.conf
sudo cp -p modules.conf.skel /etc/lighttpd/modules.conf
sudo chown root:root /etc/lighttpd/modules.conf
#
# fastcgi
sudo cp -p /etc/lighttpd/conf.d/fastcgi.conf /etc/lighttpd/conf.d/fastcgi.conf.org
sed -e s%rfriendshomedir%$homedir%g fastcgi.conf.skel > fastcgi.conf
sudo cp -p fastcgi.conf /etc/lighttpd/conf.d/fastcgi.conf
sudo chown root:root /etc/lighttpd/conf.d/fastcgi.conf
#
# webdav
sudo cp -p /etc/lighttpd/conf.d/webdav.conf /etc/lighttpd/conf.d/webdav.conf.org
sudo cp -p webdav.conf.skel /etc/lighttpd/conf.d/webdav.conf
sudo chown root:root /etc/lighttpd/conf.d/webdav.conf
cd $homedir/rfriends3/script/html
ln -nfs temp webdav
#
fi
#
#mkdir -p $homedir/lighttpd/uploads/
echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
if [ $sys -eq 1 ]; then
  sudo systemctl enable lighttpd
  sudo systemctl restart lighttpd
else 
  sudo service lighttpd restart
fi
# -----------------------------------------
echo
if [ $sys -eq 1 ]; then
  echo "type : systemd" 
else 
  echo "type : initd"
fi
echo samba : $optsamba
echo lighttpd : $optlighttpd
echo
echo current directry : $dir
echo user : $user
echo home directry : $homedir
# -----------------------------------------
#  ビルトインサーバ
#
if [ $optlighttpd != "on" ]; then
echo
echo rfriends3の実行方法
echo 
echo cd $homedir/rfriends3
echo sh rf3server.sh
echo
echo 以下が表示されるので、webブラウザでアクセス
echo
echo xxx.xxx.xxx.xxx:8000
echo
fi
# -----------------------------------------
# finish
# -----------------------------------------
echo `date`
echo finished rfriends_centos
# -----------------------------------------
