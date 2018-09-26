#!/bin/bash
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOME="/root"
HOST=$(hostname)
echo "My public IP & bind IP address: $public_ip - $bind_ip"
DEPLOY_VERSION="v"$(curl -s http://0.0.0.0:8080/deployment/version?server_type=tracker-broker&host=$HOST)
#remove existing directory
cd $HOME
rm -rf tracker
#create broker folder directory
cd $HOME
mkdir -p tracker/broker/impression tracker/broker/click tracker/broker/postback tracker/broker/filtered tracker/broker/rotated tracker/ip-server
#----Freegeoip
cd $HOME
cd tracker/ip-server
wget https://storage.g.tracker/$DEPLOY_VERSION/freegeoip
chmod 777 *
#---BROKERS
#---IMPRESSION
cd $HOME
cd tracker/broker/impression
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.broker.tracker.impression
chmod 777 *
#---CLICK
cd $HOME
cd tracker/broker/click
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.broker.tracker.click
chmod 777 *
#----POSTBACK
cd $HOME
cd tracker/broker/postback
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.broker.tracker.postback
chmod 777 *
#----Filtered
cd $HOME
cd tracker/broker/filtered
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.broker.tracker.filtered
chmod 777 *
#----ROTATED
cd $HOME
cd tracker/broker/rotated
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.broker.tracker.rotated
chmod 777 *
#start Freegeoip in 5 ports
cd $HOME
cd tracker/ip-server
nohup ./freegeoip -http localhost:5000  > nohup.out &
nohup ./freegeoip -http localhost:5001  > nohup.out &
nohup ./freegeoip -http localhost:5002  > nohup.out &
nohup ./freegeoip -http localhost:5003  > nohup.out &
nohup ./freegeoip -http localhost:5004  > nohup.out &
#start brokers
cd $HOME
cd tracker/broker/impression
nohup ./$DEPLOY_VERSION.broker.tracker.impression --broker=googlepubsub > nohup.out &
cd $HOME
cd tracker/broker/click
nohup ./$DEPLOY_VERSION.broker.tracker.click --broker=googlepubsub > nohup.out &
cd $HOME
cd tracker/broker/postback
nohup ./$DEPLOY_VERSION.broker.tracker.postback --broker=googlepubsub > nohup.out &
cd $HOME
cd tracker/broker/filtered
nohup ./$DEPLOY_VERSION.broker.tracker.filtered --broker=googlepubsub > nohup.out &
cd $HOME
cd tracker/broker/rotated
nohup ./$DEPLOY_VERSION.broker.tracker.rotated --broker=googlepubsub > nohup.out &
