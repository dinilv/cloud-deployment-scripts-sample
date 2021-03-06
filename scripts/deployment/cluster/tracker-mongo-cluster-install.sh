#!/bin/bash
HOST=$(hostname)
HOME="/root"
PKG_OK=$(sudo dpkg-query -l | grep mongod | wc -l)
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
echo "My public IP & bind IP address: $public_ip - $bind_ip"
#check installation is already completed or not
if [ $PKG_OK -eq 0 ] ;
then
  #install mongo
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
  echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org
  #change mongo conf file with arguments for replica
  sudo /bin/sh -c '(echo "replication:" ; cat file1) >> /etc/mongod.conf'
  sudo /bin/sh -c '(echo "  replSetName: tracker" ; cat file1) >> /etc/mongod.conf'
  sudo sed -i -e 's/bindIp: 127.0.0.1/bindIp: 127.0.0.1,'$bind_ip'/g' /etc/mongod.conf
  #ping master node for approving mongo replication
  curl -l "http://0.0.0.0:8080/mongo/replica/init?bind_ip="$bind_ip"&public_ip="$public_ip"&event=db_init&module=mongo&env=prod&server_type=tracker_db_cluster&host=$HOST"
  curl -l "http://0.0.0.0:8080/cluster/node/add?bind_ip="$bind_ip"&module=mongo&public_ip="$public_ip"&server_type=tracker_db_cluster&host=$HOST"
  #create scripts folder
  mkdir -p $HOME/scripts/logs
  #download scripts
  cd $HOME/scripts
  wget https://storage.cloud.google.com/tracker-db/scripts/tracker-db-disk-space.sh
  wget https://storage.cloud.google.com/tracker-db/scripts/tracker-db-free-memory.sh
  wget https://storage.cloud.google.com/tracker-db/scripts/tracker-db-system-keeper.sh
  chmod 777 *
  #add system keeper to crontab
  touch mycron.txt
  sudo crontab -l > mycron.txt
  sudo crontab -l | { cat; echo "0 */4 * * * $HOME/scripts/tracker-db-system-keeper.sh"; } | crontab -
  #add disk check script to crontab
  sudo crontab -l | { cat; echo "0 */4 * * * $HOME/scripts/tracker-db-free-memory.sh"; } | crontab -
  #add memory check script to crontab
  sudo crontab -l | { cat; echo "0 */6 * * * $HOME/scripts/tracker-db-disk-space.sh"; } | crontab -
  #add ssh keys to known hosts
  yes | ssh 35.198.238.11
  yes | ssh 35.201.178.73
  sudo reboot
else
  echo "Mongo is installed, system is getting started"
  sudo service mongod start
  curl -l "http://0.0.0.0:8080/mongo/replica/init?bind_ip="$bind_ip"&public_ip="$public_ip"&event=db_init&module=mongo&env=prod&server_type=tracker_db_cluster&host=$HOST"
  curl -l "http://0.0.0.0:8080/cluster/node/add?bind_ip="$bind_ip"&public_ip="$public_ip"&server_type=tracker_db_cluster&host=$HOST"
  curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip="$bind_ip"&public_ip="$public_ip"&event=server_start&module=mongo&env=prod&server_type=tracker_db_cluster&status=success&host=$HOST"
fi
