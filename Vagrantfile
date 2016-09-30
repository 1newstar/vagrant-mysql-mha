#节点定义
servers = { 
    "192.168.50.40" => "mysql-master", 
    "192.168.50.41" => "mysql-slave",
    "192.168.50.42" => "mysql-slave",
    "192.168.50.50" => "mha-manager"
}

shellServers = ""
servers.each{|ip, role| shellServers += "[\"#{ip}\"]=\"#{role}\"] "}

Vagrant.configure("2") do |config|
  config.vm.box = "laravel"
  config.vm.box_url = "file:///D:/vagrant-cluster/mha-cluster.box"
  ##通用虚拟机配置
  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    #vb.name = "mysql-tpl"
    vb.memory = 1024
    vb.cpus = 1
    ##设置分组
    #vb.customize ["modifyvm",:id,"--groups","/mysql-cluster"]
  end 
  
  ##ssh 如果有问题，provision是执行不了的
  #config.vm.provision "shell", path: "bootstrap.sh"  
  
  i = 0
  servers.each do |ip,role|
    i = i + 1
    node_name = "#{role}-#{i}"
    config.vm.define node_name do |node|
      node.vm.provider "virtualbox" do |vb|
        #vb.linked_clone = true
        vb.name = node_name
      end
      node.vm.network "private_network", ip: "#{ip}"
      node.vm.hostname = node_name      
      node.vm.provision "shell", path: "bootstrap.sh"
    end
    
  end
end