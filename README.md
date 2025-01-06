rfriends_stream9はCentOS Stream 9環境でrfriends3を動作させるスクリプトです。  
> [!CAUTION]
> SELinuxがenfocingの場合、Webアクセスが拒否されます。
> 簡単で安易な方法は
> sudo vi /etc/selinux/config
> SELINUX=disabled
> 変更後、再起動です。
> 

動作確認済  
CentOS Stream 9    
Rockey Linux 9.4  
alma linux 9.4  
  
cd ~/  
sudo yum install git  
git clone https://github.com/rfriends/rfriends_stream9.git  
cd rfriends_stream9  
sh rfriends3_stream9.sh  

注意）webブラウザにアドレスを入力するとき  
http://XXX.XXX.XXX.XXX:8000  
となっていることを確認してください。  
http ではエラーになります。
