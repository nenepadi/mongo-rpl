hostname "mongomaster"
echo "mongomaster" > /etc/hostname
echo "adding the ip address to hosts file"
tee -a /etc/hosts <<EOF
192.168.100.56 mongomaster
192.168.100.57 mongoslave
EOF

service mongodb stop
rm -rf /var/lib/mongodb/mongod.lock
echo "replace mongo config"
cp -f /vagrant/mongomaster.cnf /etc/mongodb.conf

# iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 27017 -j ACCEPT
# iptables-save > /etc/sysconfig/iptables
# service iptables restart

service mongodb start

echo "initialising the replicaset"
mongo <<EOF
config = { _id: "prodRepl", members:[
          { _id : 0, host : "mongomaster:27017"},
          { _id : 1, host : "mongoslave:27017"}]
        };
rs.initiate(config);
rs.status();
EOF

echo "Inserting Sample data"
mongo <<EOF
use students
db.students.insert({name: "kojo"})
db.students.insert({name: "akua"})
db.students.insert({name: "onowu"})
EOF