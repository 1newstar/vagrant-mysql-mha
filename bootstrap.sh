#!/bin/bash
hostname=$(hostname)
role=${hostname%-*}
#$role = /bin/hostname | cut -d '-' -f 1-2
ip=$(/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 10.0.2.15|grep -v inet6|awk '{print $2}'|tr -d "addr:")
#解决虚拟机克隆问题
rm -f /var/lib/mysql/auto.cnf

#安装expect工具
apt-get install expect -y

#所有主机都要安装mha
apt-get install mha4mysql-node -y 

#启用root
/vagrant/shell/enable-root.sh

#mysql node
if [ ${hostname%%-*} == "mysql" ]; then    
    
    # Master建立账号
    if [ $role == "mysql-master" ]; then
    
        #配置节点开启bin-log复制    
        server_id=${ip##*.}
        if grep -qc "server-id" /etc/mysql/my.cnf !=0; then        
            rule="s/\[mysqld\]/\[mysqld\]\nserver-id       = ${server_id}\nlog-bin         = mysql-bin/g"
            cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
            sed -i"${rule}" /etc/mysql/my.cnf
        fi
        
        mysql -u root -psecret -e "GRANT REPLICATION SLAVE ON *.* to 'repl'@'%' identified by '111111';";        
    fi

    #Slave设置
    if [ $role == "mysql-slave" ]; then
        #从节点的只读属性
        mysql -uroot -psecret -e 'set global read_only=1'
        mysql -uroot -psecret -e 'set global relay_log_purge=0'        
        mysql -u root -psecret -e "CHANGE MASTER TO MASTER_HOST='192.168.50.40', MASTER_USER='repl', MASTER_PASSWORD='111111';"        
    fi
    
    #重启mysql服务
    service mysql restart
fi

#安装配置mha manager
if [ $role == "mha-manager" ]; then
    apt-get install mha4mysql-manager -y 
    if [ ! -d "/etc/mha" ]; then
        mkdir /etc/mha
    fi
    cp /vagrant/app1.cnf /etc/mha/
fi
