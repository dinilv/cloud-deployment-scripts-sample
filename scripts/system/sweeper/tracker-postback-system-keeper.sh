#!/bin/bash
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/var"
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
curl -F "file=@$HOME/platform/consul/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=consul" -F "module=consul" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/micro/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=micro" -F "module=micro" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/ip-server/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=freegeoip" -F "module=freegeoip" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/api/postback/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=api_postback" -F "module=api_postback" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/services/postback/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=service_postback" -F "module=service_postback" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/services/postbackoffermedia/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=service_postbackoffermedia" -F "module=service_postbackoffermedia" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/postback/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_postback" -F "module=subscriber_postback" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/filtered/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_filtered" -F "module=subscriber_filtered" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/delayed/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_delayed" -F "module=subscriber_delayed" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/postback_ping/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_postback_ping" -F "module=subscriber_postback_ping" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health

#components logs
sudo truncate -s 0 $HOME/platform/consul/nohup.out

#truncate app logs
sudo truncate -s 0 $HOME/tracker/micro/nohup.out
sudo truncate -s 0 $HOME/tracker/ip-server/nohup.out
sudo truncate -s 0 $HOME/tracker/api/postback/nohup.out
sudo truncate -s 0 $HOME/tracker/services/postback/nohup.out
sudo truncate -s 0 $HOME/tracker/services/postbackoffermedia/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/postback/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/postback_ping/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/filtered/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/delayed/nohup.out
