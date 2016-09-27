#!/bin/bash

./change-root-pwd

if [ $(grep -c "PermitRootLogin yes" /etc/ssh/sshd_config) -eq 0 ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    #反向引用
    rule="28 s/\(PermitRootLogin\swithout-password\)/\#\1\nPermitRootLogin yes/g"
    sed -i "${rule}" /etc/ssh/sshd_config
fi


