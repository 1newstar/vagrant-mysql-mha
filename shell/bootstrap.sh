#!/bin/bash
ip=$1
role=$2

#解决虚拟机克隆问题
rm -f /var/lib/mysql/auto.cnf

#安装expect工具
apt-get install expect -y

#所有主机都要安装mha
apt-get install mha4mysql-node -y 

#启用root
./enable-root

#配置mysql
./mysql-node $ip $role

#配置mha manager
./mha-manager $ip $role







