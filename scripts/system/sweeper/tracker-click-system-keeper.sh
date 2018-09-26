#!/bin/bash
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/var"
GSUTIL="/usr/bin/gsutil"
#clear cache
sudo sysctl -w vm.drop_caches=3
#delete systemd log files
cd /var/log/journal
sudo rm -rf *
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
# push logs for storage
curl -F "file=@$HOME/platform/consul/nohup.out;" -F "server_type=tracker_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=consul" -F "module=consul" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@/var/log/redis/redis-server.log;" -F "server_type=tracker_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=redis" -F "module=app" -F "env=redis" -F "file_name=redis-server.log" http://0.0.0.0:8080/cluster/node/health

micro_file=$(curl -s  "http://0.0.0.0:8080/cluster/node/health?server_type=tracker_click&public_ip="$public_ip"bind_ip="$bind_ip"&event=micro&module=micro&env=prod&file_name=nohup.out&host="$HOST)
api_file=$(curl -s  "http://0.0.0.0:8080/cluster/node/health?server_type=tracker_click&public_ip="$public_ip"bind_ip="$bind_ip"&event=api_click&module=api_click&env=prod&file_name=nohup.out&host="$HOST)
mv $HOME/tracker/micro/nohup.out $HOME/tracker/micro/$micro_file
mv $HOME/tracker/api/click/nohup.out $HOME/tracker/api/click/$api_file

$GSUTIL cp $HOME/tracker/micro/nohup.out gs://tracker-logs/tracker_click/micro/$public_ip
$GSUTIL cp $HOME/tracker/api/click/nohup.out gs://tracker-logs/tracker_click/api_click/$public_ip

curl -F "file=@$HOME/tracker/ip-server/nohup.out;" -F "server_type=tracker_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=freegeoip" -F "module=freegeoip" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/click/nohup.out;" -F "server_type=tracker_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_click" -F "module=subscriber_click" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/rotated/nohup.out;" -F "server_type=tracker_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_rotated" -F "module=subscriber_rotated" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health

#components logs
sudo truncate -s 0 $HOME/platform/consul/nohup.out
sudo truncate -s 0 /var/log/redis/redis-server.log

#truncate app logs
sudo truncate -s 0 $HOME/tracker/micro/nohup.out
sudo truncate -s 0 $HOME/tracker/ip-server/nohup.out
sudo truncate -s 0 $HOME/tracker/api/click/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/click/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/rotated/nohup.out
