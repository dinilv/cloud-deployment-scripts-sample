#!/bin/bash
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/var"
# file system disk information
cd $HOME/scripts/logs
truncate -s 0 scanner.txt
touch scanner.txt
error_keywords=""
error_keywords="${error_keywords}  panic "
error_keywords="${error_keywords}  error "
error_keywords="${error_keywords}  go.micro.client "
error_keywords="${error_keywords}  go.micro.api "
error_keywords="${error_keywords}  go.micro.service "
file_array=""
file_array="${file_array} /var/tracker/micro/nohup.out"
file_array="${file_array} /var/tracker/ip-server/nohup.out"
file_array="${file_array} /var/tracker/broker/exception/nohup.out"
file_array="${file_array} /var/tracker/api/click/nohup.out"
file_array="${file_array} /var/tracker/broker/exception/nohup.out"
file_array="${file_array} /var/tracker/subscriber/click/nohup.out"
file_array="${file_array} /var/tracker/subscriber/rotated/nohup.out"
date=$(date +'%d-%m-%Y %H:%M:%S' >> scanner.txt)
error_keywords_array=$(echo $error_keywords | tr " " "\n")
file_names=$(echo $file_array | tr " " "\n")
for file_name in $file_names
do
  grep -a -inR -C1 ' 500 ' $file_name >> scanner.txt
  for error_keyword in $error_keywords_array
  do
    grep -a -inR -C1 $error_keyword $file_name >> scanner.txt
  done
done

curl -F "file=@scanner.txt;" -F "server_type=tracker_click" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=error_scanner" -F "module=error_scanner" -F "env=prod" -F "file_name=scanner.txt" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
