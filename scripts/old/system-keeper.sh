#!/bin/bash
#remove cache clearence folder

# file system disk information
sudo du -h / | grep '[0-9\.]\+G'
#delete nginx log files
sudo rm /var/log/nginx/access.log.*
sudo rm /var/log/nginx/error.log.*
sudo truncate -s 0  /var/log/nginx/error.log /var/log/nginx/access.log
#truncate application log for daily
#delete systemd log files
cd /var/log/journal
sudo rm -rf *
#truncate db log files
#---TO-DO-delete elastic search log
sudo rm -rf /home/server/platform/elastic/logs/elasticsearch-*
sudo truncate -s 0 /var/log/mongodb/mongod.log
sudo truncate -s 0 /var/log/redis_6379.log
sudo truncate -s 0 /home/server/platform/elastic/logs/elasticsearch.log
#sudo truncate -s 0 /var/log/redis/redis-server.log

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
#delete ui logs
sudo truncate -s 0 /home/server/code/ui/ad-server-ui/log/passenger.3000.log
sudo truncate -s 0 /home/server/code/ui/ad-server-ui/log/development.log
#delete app logs
sudo truncate -s 0 /home/server/code/go/bin/tracker/micro/nohup.out
sudo truncate -s 0 /home/server/code/go/bin/tracker/api/nohup.out
sudo truncate -s 0 /home/server/code/go/bin/tracker/server/nohup.out
sudo truncate -s 0 /home/server/code/go/bin/tracker/ip/nohup.out
sudo truncate -s 0 /home/server/code/go/bin/tracker/services/nohup.out
sudo truncate -s 0 /home/server/code/go/bin/nohup.out
