#!/usr/bin/expect 

##修改root密码
set pw 111111 
spawn passwd
#Enter new UNIX password:
expect "password:" 
send "$pw\r"
#Retype new UNIX password:
expect "password:" 
send "$pw\r"
expect eof



