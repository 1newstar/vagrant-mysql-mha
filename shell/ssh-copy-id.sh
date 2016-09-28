#!/usr/bin/expect 
set ip [lindex $argv 0];
set pw 111111
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$ip
expect 'password:' 
send "$pw\r"
expect eof
