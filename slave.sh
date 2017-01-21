hostname "mongoslave"
echo "mongoslave" > /etc/hostname
echo "adding the ip address to hosts file"
tee -a /etc/hosts <<EOF
192.168.100.56 mongomaster
192.168.100.57 mongoslave
EOF

service mongodb stop
sudo rm -rf /var/lib/mongodb/mongod.lock
echo "replace mongo config"
cp -f /vagrant/mongomaster.cnf /etc/mongodb.conf

# iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 27017 -j ACCEPT
# iptables-save > /etc/sysconfig/iptables
# service iptables restart

echo "start mongo server"
service mongodb start