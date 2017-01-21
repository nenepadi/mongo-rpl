# -*- mode: ruby -*-
# vi: set ft=ruby :

$mongoInstall = <<-"SCRIPT"
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
    apt-get update
    apt-get -y install mongodb-10gen
    mkdir -p /data/db

    cp -f /vagrant/backup.sh ./backup.sh
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.boot_timeout = 500

    config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--cpus", "2"]
        v.customize ["modifyvm", :id, "--nictype1", "Am79C973"]
        v.customize ["modifyvm", :id, "--nictype2", "Am79C973"]
    end

    config.vm.define "master" do |master|
        master.vm.network :private_network, ip: "192.168.100.56", auto_config: false
        master.vm.provision "shell", inline: <<-"SHELL"
            rm -f /etc/network/interfaces.d/eth1.cfg
            echo "auto eth1" >> /etc/network/interfaces.d/eth1.cfg
            echo "iface eth1 inet static" >> /etc/network/interfaces.d/eth1.cfg
            echo "address 192.168.100.56" >> /etc/network/interfaces.d/eth1.cfg
            echo "netmask 255.255.255.0" >> /etc/network/interfaces.d/eth1.cfg
            ifdown eth1 && ifup eth1
        SHELL
        master.vm.provision "shell", inline: $mongoInstall
        master.vm.provision "shell", path: "master.sh"
    end

    config.vm.define "slave" do |slave|
        slave.vm.network :private_network, ip: "192.168.100.57", auto_config: false
        slave.vm.provision "shell", inline: <<-"SHELL"
            rm -f /etc/network/interfaces.d/eth1.cfg
            echo "auto eth1" >> /etc/network/interfaces.d/eth1.cfg
            echo "iface eth1 inet static" >> /etc/network/interfaces.d/eth1.cfg
            echo "address 192.168.100.57" >> /etc/network/interfaces.d/eth1.cfg
            echo "netmask 255.255.255.0" >> /etc/network/interfaces.d/eth1.cfg
            ifdown eth1 && ifup eth1
        SHELL
        slave.vm.provision "shell", inline: $mongoInstall
        slave.vm.provision "shell", path: "slave.sh"
    end
end
