#!/bin/bash
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/home/adcamie/scripts"
# file system disk information
cd $HOME/scripts/logs
truncate -s 0 monitor.txt
touch monitor.txt
date=$(date +'%d-%m-%Y %H:%M:%S' >> monitor.txt)
disk=$(df -h >> monitor.txt)
#inform=$(sudo du -h / | grep '[0-9\.]\+G' >> monitor.txt)
curl -F "file=@monitor.txt;" -F "server_type=tracker_mongo_master" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=disk_check" -F "module=db" -F "env=prod" -F "file_name=monitor.txt" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
# memory information
cd $HOME/scripts/logs
truncate -s 0 memory.txt
touch memory.txt
date=$(date +'%d-%m-%Y %H:%M:%S' > memory.txt)
free=$(free -m >> memory.txt)
inform=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head >> memory.txt)
curl -F "file=@memory.txt;" -F "server_type=tracker_mongo_master" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=memory_check" -F "module=db" -F "env=prod" -F "file_name=memory.txt" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
#clear cache
sudo sysctl -w vm.drop_caches=3
#truncate db logs
sudo truncate -s 0 /var/log/mongodb/mongod.log
#truncate system logs
sudo truncate -s 0 /var/log/term.log /var/log/apt/history.log /var/log/auth.log /var/log/syslog
sudo truncate -s 0 /var/log/kern.log /var/log/apport.log /var/log/dpkg.log /var/log/alternatives.log
sudo truncate -s 0 /var/log/wtmp  /var/log/btmp /var/log/lastlog /var/log/syslog
sudo truncate -s 0 /var/log/cloud-init.log /var/log/cloud-init-output.log
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
