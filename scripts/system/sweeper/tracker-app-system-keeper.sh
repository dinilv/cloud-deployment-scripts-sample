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
curl -F "file=@$HOME/platform/consul/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=consul" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/micro/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=micro" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/ip-server/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=freegeoip" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
#brokers
curl -F "file=@$HOME/tracker/broker/impression/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=broker_impression" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/broker/click/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=broker_click" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/broker/postback/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=broker_postback" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/broker/filtered/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=broker_filtered" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/broker/rotated/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=broker_rotated" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
#subscribers
curl -F "file=@$HOME/tracker/subscriber/impression/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_impression" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/click/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_click" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/postback/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_postback" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/filtered/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_filtered" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/rotated/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_rotated" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
#api
curl -F "file=@$HOME/tracker/api/impression/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=api_impression" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/api/click/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=api_click" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/api/postback/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=api_postback" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/services/postback/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=service_postback" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/services/postbackoffermedia/nohup.out;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=service_postbackoffermedia" -F "module=app" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@/var/log/redis/redis-server.log;" -F "server_type=tracker_app_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=redis" -F "module=app" -F "env=prod" -F "file_name=redis-server.log" http://0.0.0.0:8080/cluster/node/health

#components logs
sudo truncate -s 0 $HOME/platform/consul/nohup.out
sudo truncate -s 0 /var/log/redis/redis-server.log
sudo truncate -s 0 $HOME/tracker/micro/nohup.out
sudo truncate -s 0 $HOME/tracker/ip-server/nohup.out
#brokers
sudo truncate -s 0 $HOME/tracker/broker/impression/nohup.out
sudo truncate -s 0 $HOME/tracker/broker/click/nohup.out
sudo truncate -s 0 $HOME/tracker/broker/postback/nohup.out
sudo truncate -s 0 $HOME/tracker/broker/filtered/nohup.out
sudo truncate -s 0 $HOME/tracker/broker/rotated/nohup.out
#subscribers
sudo truncate -s 0 $HOME/tracker/subscriber/impression/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/click/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/postback/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/filtered/nohup.out
sudo truncate -s 0 $HOME/tracker/subscriber/rotated/nohup.out
#api
sudo truncate -s 0 $HOME/tracker/api/impression/nohup.out
sudo truncate -s 0 $HOME/tracker/api/click/nohup.out
sudo truncate -s 0 $HOME/tracker/api/postback/nohup.out
#service
sudo truncate -s 0 $HOME/tracker/services/postback/nohup.out
sudo truncate -s 0 $HOME/tracker/services/postbackoffermedia/nohup.out
