#!/bin/bash
pw=111111
if [ $(grep -c "PermitRootLogin yes" /etc/ssh/sshd_config) -eq 0 ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    #反向引用
    rule="28 s/\(PermitRootLogin\swithout-password\)/\#\1\nPermitRootLogin yes/g"
    sed -i "${rule}" /etc/ssh/sshd_config
fi

if [ ! -f "/root/.ssh/id_rsa" ] ;then 
    ##修改root密码
    /usr/bin/expect <<EOF
set timeout 5

spawn passwd
expect {
    "Enter" {send "$pw\r";exp_continue}
    "Retype" {send "$pw\r"}
}
expect eof
EOF

    ##证书免登陆
    /usr/bin/expect <<EOF
set timeout 3
spawn ssh-keygen -t rsa -P ""
expect {
    "Enter" {send "\r"}
}
expect eof
EOF
fi

service ssh restart
