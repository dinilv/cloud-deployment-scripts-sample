#!/bin/bash
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/home/adcamie"
echo "My public IP & bind IP address: $public_ip - $bind_ip"
DEPLOY_VERSION="v"$(curl -s http://0.0.0.0:8080/deployment/version?server_type=tracker_job&host=$HOST)
#remove directory
cd $HOME
rm -rf tracker
#stop running jobs
alert_pid=$(ps -ef | grep alert | grep -v grep | awk '{print $2}')
big_query_pid=$(ps -ef | grep big_query_upload | grep -v grep | awk '{print $2}')
kill -9 $big_query_pid $alert_pid
#create app file directory
cd $HOME
mkdir -p tracker/alert tracker/bigquery
#download app files one by one
#---ALERT
cd tracker/alert
wget https://storage.g.tracker/jobs/alert
chmod 777 *
nohup ./alert &
#----BIGQUERY
cd $HOME
cd tracker/bigquery
wget https://storage.g.tracker/jobs/bigquery
chmod 777 *
nohup ./big_query_upload &
