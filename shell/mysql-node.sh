#!/bin/bash
ip=$1
role=$2

#安装配置mha
apt-get install mha4mysql-node -y #所有主机都要安装mha
if [ server_id -eq 50 ]; then
    apt-get install mha4mysql-manager -y #mha manager
    if [ ! -d "/etc/mha" ]; then
        mkdir /etc/mha
    fi
    cp /vagrant/app1.cnf /etc/mha/
fi

#配置节点开启bin-log复制
#ip=$(/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 10.0.2.15|grep -v inet6|awk '{print $2}'|tr -d "addr:")
server_id=${ip##*.}
if grep -qc "server-id" /etc/mysql/my.cnf !=0; then        
    rule="s/\[mysqld\]/\[mysqld\]\nserver-id       = ${server_id}\nlog-bin         = mysql-bin/g"
    cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
    sed -i"${rule}" /etc/mysql/my.cnf
fi

# Master建立账号
if [ $role == "mysql-master" ]; then
    mysql -u root -psecret -e "GRANT REPLICATION SLAVE ON *.* to 'repl'@'%' identified by '111111';";
    #重启mysql服务
    service mysql restart
fi

#Slave设置
if [ $role == "mysql-slave"]; then
    #从节点的只读属性
    mysql -uroot -psecret -e 'set global read_only=1'
    mysql -uroot -psecret -e 'set global relay_log_purge=0'
    
    mysql -u root -psecret -e "CHANGE MASTER TO MASTER_HOST='192.168.50.40', MASTER_USER='repl', MASTER_PASSWORD='111111';"    
    #重启mysql服务
    service mysql restart
fi

