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
# -----------------------------------------
sys=`pgrep -o systemd`
ar=`dpkg --print-architecture`
bit=`getconf LONG_BIT`
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
sudo yum update 
sudo yum -y install dnsutils p7zip net-tools unzip nano vim tzdata at cronie wget curl 
sudo yum -y install php-cli php-xml php-zip php-mbstring php-json php-curl php-intl 
sudo yum -y install ffmpeg ffmpeg-devel

#sudo yum -y install AtomicParsley
#wget https://mirror.perchsecurity.com/pub/archive/fedora/linux/releases/36/Everything/x86_64/os/Packages/a/AtomicParsley-0.9.5-19.fc36.x86_64.rpm  
sudo rpm -ivh AtomicParsley-0.9.5-19.fc36.x86_64.rpm 

sudo yum -y install chromium
sudo yum -y install openssh-server
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
echo
echo install samba
echo
# -----------------------------------------
if [ $optsamba = "on" ]; then
sudo yum -y install samba
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

if [ $sys = "1" ]; then
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
if [ $optlighttpd="on" ]; then
#sudo yum -y install lighttpd lighttpd-mod-webdav php-cgi
sudo yum -y install lighttpd php-cgi

LCONF=/etc/lighttpd

HTDOCS=$homedir/rfriends3/script/html

sudo mkdir /var/log/lighttpd
sudo mkdir /var/lib/lighttpd
sudo mkdir -p /var/cache/lighttpd
sudo mkdir $homedir/sockets

mkdir -p $HTDOCS/temp
ln -s $HTDOCS/temp $HTDOCS/webdav

sudo mv -n $LCONF/lighttpd.conf $LCONF/lighttpd.conf.org
sudo mv -n $LCONF/modules.conf  $LCONF/modules.conf.org
#sudo mv -n $LCONF/conf.d/fastcgi.conf    $LCONF/conf.d/fastcgi.conf.org

cd $dir

sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel > lighttpd.conf
sed -i s%rfriendsuser%$user%g lighttpd.conf
sudo cp -p lighttpd.conf $LCONF/lighttpd.conf
sudo chown root:root $LCONF/lighttpd.conf

sudo cp -f modules.conf  $LCONF/modules.conf
#sudo cp -f fastcgi.conf  $LCONF/conf.d/fastcgi.conf 

sudo sed -i 's/#webdav.is-readonly/webdav.is-readonly/'       $LCONF/conf.d/webdav.conf
sudo sed -i 's/#webdav.sqlite-db-name/webdav.sqlite-db-name/' $LCONF/conf.d/webdav.conf
sudo sed -i 's/webdav.sqlite-db-name/#webdav.sqlite-db-name/' $LCONF/conf.d/webdav.conf
sudo sed -i 's/#dir-listing.activate/dir-listing.activate/'   $LCONF/conf.d/dirlisting.conf
sudo sed -i 's/#dir-listing.external-css/dir-listing.external-css' $LCONF/conf.d/dirlisting.conf

echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt

if [ $sys = "1" ]; then
  systemctl enable lighttpd
  systemctl restart lighttpd
else 
  service lighttpd restart
fi
fi
# -----------------------------------------
# systemd or service
# -----------------------------------------
if [ $sys = "1" ]; then
  systemctl enable atd
  systemctl enable cron
else 
  service atd restart
  service cron restart
fi
# -----------------------------------------
echo
echo architecture : $ar $bit bits
if [ $sys = "1" ]; then
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
#  アクセスアドレス
# -----------------------------------------
cd $homedir
port=8000
ip=`sh $homedir/rfriends3/getIP.sh`
server=${ip}:${port}
echo
echo システムを再起動後、
echo ブラウザで、http://$server にアクセスしてください。
echo
# -----------------------------------------
# finish
# -----------------------------------------
echo `date`
echo finished rfriends_centos
# -----------------------------------------
