#!/bin/bash
hostname=$(hostname)
$role = ${hostname%-*}
#$role = /bin/hostname | cut -d '-' -f 1-2
#安装配置mha manager
if [ $role == 'mha-manager' ]; then
    apt-get install mha4mysql-manager -y 
    if [ ! -d "/etc/mha" ]; then
        mkdir /etc/mha
    fi
    cp /vagrant/app1.cnf /etc/mha/
fi
