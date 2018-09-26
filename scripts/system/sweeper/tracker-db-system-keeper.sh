#!/bin/bash
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/root"
#clear acahe
sudo sysctl -w vm.drop_caches=3
#delete systemd log files
cd /var/log/journal
sudo rm -rf *
#push logs for storage
curl -F "file=@/var/log/mongodb/mongod.log;" -F "server_type=tracker_db_cluster" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=mongo" -F "module=app" -F "env=prod" -F "file_name=mongod.log" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@/var/log/redis/redis-server.log;" -F "server_type=tracker_db_cluster" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=redis" -F "module=app" -F "env=prod" -F "file_name=redis-server.log" http://0.0.0.0:8080/cluster/node/health
#truncate db log files
sudo truncate -s 0 /var/log/mongodb/mongod.log
sudo truncate -s 0 /var/log/redis/redis-server.log
#truncate all logs
sudo truncate -s 0 /var/log/term.log /var/log/apt/history.log /var/log/auth.log /var/log/syslog
sudo truncate -s 0 /var/log/kern.log /var/log/apport.log /var/log/dpkg.log /var/log/alternatives.log
sudo truncate -s 0 /var/log/wtmp  /var/log/btmp /var/log/lastlog /var/log/syslog
sudo truncate -s 0 /var/log/cloud-init.log /var/log/cloud-init-output.log
#remove logs
sudo rm /var/log/term.log.*
sudo rm /var/log/apt/history.log.*
sudo rm /var/log/auth.log.*
sudo rm /var/log/syslog.*
sudo rm /var/log/kern.log.*
sudo rm /var/log/apport.log.*
sudo rm /var/log/dpkg.log.*
sudo rm /var/log/alternatives.log.*
sudo rm /var/log/wtmp.*
sudo rm /var/log/btmp.*
