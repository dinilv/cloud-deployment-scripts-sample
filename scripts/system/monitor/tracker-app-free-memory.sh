#!/bin/bash
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/var"
# file system disk information
cd $HOME/scripts/logs
truncate -s 0 memory.txt
touch memory.txt
date=$(date +'%d-%m-%Y %H:%M:%S' > memory.txt)
free=$(free -m >> memory.txt)
inform=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head >> memory.txt)
curl -F "file=@memory.txt;" -F "server_type=tracker_app_cluster" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=memory_check" -F "module=db" -F "env=prod" -F "file_name=memory.txt" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
