#!/bin/bash
service ssh restart
##由于vagrant是逐台启动的，所以分发必须是所有机器都启动完成之后才能执行。
##参数整理
GETOPT_ARGS=`getopt -o l:s -al local-host-ip:,servers: -- "$@"`
eval set -- "$GETOPT_ARGS"
opt_local_host_ip=""
opt_servers=""
while true ; do
    case "$1" in
        -l|--local-host-ip) opt_local_host_ip=$2; shift 2;;
        -s|--servers) opt_servers=$2; shift 2;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


##转换为kev-value关联数组
declare -A servers="(${opt_servers})"
local_host_ip=$opt_local_host_ip


##证书分发
for ip in ${!servers[@]} ;do
    if [ $local_host_ip == $ip ]; then
        continue
    fi
    #ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.50.42    
    ./ssh-copy-id.sh $ip
done

#./a.sh --current=192.168.50.40 --servers='["192.168.50.40"]="mysql-master" ["192.168.50.41"]="mysql-slave" ["192.168.50.42"]="mysql-slave"'
#./a.sh --local-host-ip=192.168.50.41 --servers='["192.168.50.40"]="mysql-master" ["192.168.50.41"]="mysql-slave" ["192.168.50.42"]="mysql-slave"'
#./a.sh --local-host-ip=192.168.50.41 --servers='[192.168.50.40]=mysql-master [192.168.50.41]=mysql-slave [192.168.50.42]=mysql-slave'