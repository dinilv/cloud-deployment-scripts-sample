#!/bin/bash
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/var"
# file system disk information
cd $HOME/scripts/logs
truncate -s 0 monitor.txt
touch monitor.txt
date=$(date +'%d-%m-%Y %H:%M:%S' >> monitor.txt)
disk=$(df -h >> monitor.txt)
inform=$(sudo du -h / | grep '[0-9\.]\+G' >> monitor.txt)
curl -F "file=@monitor.txt;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=disk_check" -F "module=db" -F "env=prod" -F "file_name=monitor.txt" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
