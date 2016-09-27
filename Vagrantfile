#节点定义
nodes = { 
    "192.168.50.40" => "mysql-master", 
    "192.168.50.41" => "mysql-slave",
    "192.168.50.42" => "mysql-slave",
    "192.168.50.50" => "mha-manager"
}

shellNodes = ""
nodes.each{|ip, role| shellNodes += "[\"#{ip}\"]=\"#{role}\"] "}

Vagrant.configure("2") do |config|

  config.vm.box = "laravel"
  config.vm.box_url = "file:///d:/downloadbox/laravel-homestead-0.4.4.box"#已下载好的box  
  ##通用虚拟机配置
  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    #vb.name = "mysql-tpl"
    vb.memory = 1024
    vb.cpus = 1
    ##设置分组
    #vb.customize ["modifyvm",:id,"--groups","/mysql-cluster"]
  end
  
  ##网络配置尝试
  #config.vm.network "private_network", adapter: 1, type: "dhcp"
  
  ##ssh 问题各种尝试。（默认是端口转发和私钥认证登录）
  #config.ssh.insert_key = false#不生成私钥
  #config.ssh.username = "vagrant"
  #config.ssh.password = "vagrant"#使用密码方式登录
  #config.ssh.forward_agent = true
  #config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: true
  #config.vm.network "forwarded_port", guest: 22, host: 2300, adapter: 2
  
  
  ##ssh 如果有问题，provision是执行不了的
  #config.vm.provision "shell", path: "bootstrap.sh"

  ##master配置
  config.vm.define "mysql-master1" do |mysql_master|
    mysql_master.vm.provider "virtualbox" do |vb|
      #vb.linked_clone = true
      vb.name = "mysql-master1"
      #vb.gui = true
      #vb.customize ["modifyvm",:id,"--groups","/mysql-cluster"]
    end
    ##就算设置完private_network，永远有个eth0且IP为10.0.2.15，这个怎么破？
    #mysql_master.vm.network "private_network", ip: "192.168.50.40", auto_config: false
    mysql_master.vm.network "private_network", ip: "192.168.50.40"
    mysql_master.vm.hostname = "mysql-master"
  end
  
  ##slave配置
  (1..2).each do |i|
    node_name = "mysql-slave#{i}"
    config.vm.define node_name do |node|
      node.vm.provider "virtualbox" do |vb|
        #vb.linked_clone = true
        vb.name = node_name
      end
      node.vm.network "private_network", ip: "192.168.50.4#{i}"
      node.vm.hostname = node_name
      
      # node.vm.provision "shell", path: "slave-bootstrap.sh {node_name}"
    end
  end
  
  ##master配置
  config.vm.define "mha-manager" do |mha|
    mha.vm.provider "virtualbox" do |vb|
      vb.name = "mha-manager"
    end
    mha.vm.network "private_network", ip: "192.168.50.50"
    mha.vm.hostname = "mha-manager"
  end
  
end