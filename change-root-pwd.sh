#!/usr/bin/expect 

##修改root密码
set pw 111111 
spawn passwd
#Enter new UNIX password:
send "$pw\r"
#Retype new UNIX password:
expect 'Retype' 
send "$pw\r"
expect eof

##证书免登陆
if [ ! -f "/root/.ssh/id_rsa.pub" ] ;then    
    spawn ssh-keygen -t rsa -P ''
    #Enter file in which to save the key (/root/.ssh/id_rsa): 
    expect 'Enter'
    send "\r"
    #Enter passphrase (empty for no passphrase): 
    expect 'Enter'
    send "\r"
    #Enter same passphrase again:
    expect 'Enter'
    send "\r"
    expect eof
fi


