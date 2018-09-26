#!/bin/bash
HOST=$(hostname)
HOME="/root"
PKG_OK=$(sudo dpkg-query -l | grep redis-server | wc -l)
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
echo "My public IP & bind IP address: $public_ip - $bind_ip"
#check installation is already completed or not
if [ $PKG_OK -eq 0 ] ;
then
  #change file limits
  cd
  touch file1
  sudo /bin/sh -c '(echo "*    soft nofile 1048576" ; cat file1) >> /etc/security/limits.conf'
  sudo /bin/sh -c '(echo "*    hard nofile 1048576" ; cat file1) >> /etc/security/limits.conf'
  #install redis
  sudo add-apt-repository ppa:chris-lea/redis-server
  sudo apt-get update
  sudo apt-get -y install redis-server
  #copy new settings for redis-slave
  sudo /bin/sh -c '(echo "slaveof 35.201.178.73 6379" ; cat file1) >> /etc/redis/redis.conf'
  sudo /bin/sh -c '(echo "requirepass server@123" ; cat file1) >> /etc/redis/redis.conf'
  sudo /bin/sh -c '(echo "masterauth server@123" ; cat file1) >> /etc/redis/redis.conf'
  #ping cluster log for redis replication
  curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip=$bind_ip&public_ip=$public_ip&event=db_init&module=redis&env=prod&server_type=tracker_db_cluster&host=$HOST"
  #restart redis
  sudo service redis-server restart
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
  ssh 35.198.238.11
  ssh 35.201.178.73
else
  echo "Redis are installed, system is getting started"
  curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip="$bind_ip"&public_ip="$public_ip"&event=server_start&module=redis&env=prod&server_type=tracker_db_cluster&status=success&host=$HOST"
fi
