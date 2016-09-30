#!/usr/bin/expect 
set ip [lindex $argv 0];
set pwd 111111
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$ip
expect {
    "yes/no" {send "yes\r"; exp_continue}
    "password:" {send "$pwd\r"}
}
expect eof