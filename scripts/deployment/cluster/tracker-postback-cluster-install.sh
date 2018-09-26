#!/bin/bash
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/var"
echo "My public IP & bind IP address: $public_ip - $bind_ip"
VERSION=$(curl -s http://0.0.0.0:8080/deployment/version?server_type=tracker_postback&host=$HOST)
DEPLOY_VERSION=""
if [ -z "$VERSION" ]; then
   echo "Empty version string"
   DEPLOY_VERSION="v1"
else
    DEPLOY_VERSION="v"$VERSION
fi
#apt install golang-go
if [ -d "$HOME/tracker" ] ; then
    echo "Installation directories already exist."
    #remove & create consul dir
    rm -rf $HOME/platform/consul/data
    mkdir -p $HOME/platform/consul/data
    #start consul
    cd $HOME/platform/consul
    ./consul agent -bootstrap -server -data-dir=$HOME/platform/consul/data -ui -bind=0.0.0.0 -client=0.0.0.0 > nohup.out &
    #ping cluster listner
    curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip="$bind_ip"&public_ip="$public_ip"&event=pkg_init&module=consul&env=prod&server_type=tracker_postback&status=success&host=$HOST"
    #remove existing applciation
    rm -rf $HOME/tracker
    #for file issues
    sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled
    sudo sysctl -w net.core.somaxconn=80000
    sudo sysctl -w fs.file-max=80000
    sudo sysctl -w vm.max_map_count=262144
    sudo ulimit -n 1048576
else
    #add for file issues
    sudo /bin/sh -c '(echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" ; cat file1) > /etc/rc.local'
    sudo /bin/sh -c '(echo "vm.overcommit_memory = 1" ; cat file1) >> /etc/sysctl.conf'
    sudo /bin/sh -c '(echo "sysctl -w fs.file-max=80000" ; cat file1) >> /etc/sysctl.conf'
    sudo /bin/sh -c '(echo "net.core.somaxconn=80000" ; cat file1) >> /etc/sysctl.conf'
    sudo /bin/sh -c '(echo "vm.max_map_count=262144" ; cat file1) >> /etc/sysctl.conf'
    sudo /bin/sh -c '(echo "net.ipv4.tcp_max_syn_backlog=80000" ; cat file1) >> /etc/sysctl.conf'
    sudo /bin/sh -c '(echo "65535" ; cat file1) > /proc/sys/net/core/somaxconn'
    sudo /bin/sh -c '(echo "session required pam_limits.so" ; cat file1) > /etc/pam.d/common-session'

    #change file limits
    sudo /bin/sh -c '(echo "*    soft nofile 1048576" ; cat file1) >> /etc/security/limits.conf'
    sudo /bin/sh -c '(echo "*    hard nofile 1048576" ; cat file1) >> /etc/security/limits.conf'
    sudo /bin/sh -c '(echo "root soft nofile 1048576" ; cat file1) >> /etc/security/limits.conf'
    sudo /bin/sh -c '(echo "root hard nofile 1048576" ; cat file1) >> /etc/security/limits.conf'

    #install unzip
    yes | sudo apt-get install zip
    #create consul directory
    cd $HOME
    mkdir -p platform/consul
    mkdir -p platform/consul/data
    cd platform/consul
    #install consul
    wget https://releases.hashicorp.com/consul/1.0.2/consul_1.0.2_linux_amd64.zip?_ga=2.200509420.354500350.1516085562-1952982229.1511942221
    mv consul_1.0.2_linux_amd64.zip?_ga=2.200509420.354500350.1516085562-1952982229.1511942221 consul.zip
    unzip consul.zip
    rm consul.zip
    #start consul
    chmod 777 consul
    ./consul agent -bootstrap -server -data-dir=$HOME/platform/consul/data -ui -bind=0.0.0.0 -client=0.0.0.0 > nohup.out &
    #ping cluster listner
    curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip="$bind_ip"&public_ip="$public_ip"&event=server_init&module=consul&env=prod&server_type=tracker_postback&status=success&host=$HOST"
    #create scripts folder
    mkdir -p $HOME/scripts/logs
    #download scripts
    cd $HOME/scripts
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-postback-error-scanner.sh
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-postback-disk-space.sh
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-postback-free-memory.sh
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-postback-system-keeper.sh
    chmod 777 *
    #add system keeper to crontab
    touch mycron.txt
    sudo crontab -l > mycron.txt
    sudo crontab -l | { cat; echo "0 */4 * * * $HOME/scripts/tracker-postback-error-scanner.sh"; } | crontab -
    sudo crontab -l | { cat; echo "0 */4 * * * $HOME/scripts/tracker-postback-system-keeper.sh"; } | crontab -
    sudo crontab -l | { cat; echo "0 */4 * * * $HOME/scripts/tracker-postback-free-memory.sh"; } | crontab -
    sudo crontab -l | { cat; echo "0 */6 * * * $HOME/scripts/tracker-postback-disk-space.sh"; } | crontab -
    #add ssh keys to known hosts
    ssh 35.198.238.11
    ssh 35.201.178.73
    #shutdown & restart
    sudo reboot
fi
#create app file directory
cd $HOME
mkdir -p tracker/micro tracker/ip-server tracker/api/postback tracker/services/postback tracker/services/postbackoffermedia
mkdir -p tracker/broker/exception
mkdir -p tracker/subscriber/postback tracker/subscriber/filtered tracker/subscriber/delayed tracker/subscriber/postback_ping
#download app files one by one
#---MICRO
cd $HOME
cd tracker/micro
wget https://storage.g.tracker/$DEPLOY_VERSION/micro
chmod 777 *
#----Freegeoip
cd $HOME
cd tracker/ip-server
wget https://storage.g.tracker/$DEPLOY_VERSION/freegeoip
chmod 777 *
#---BROKERS
#----Filtered
cd $HOME
cd tracker/broker/exception
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.broker.tracker.exception
chmod 777 *
#---SUBSCRIBERS
#----POSTBACK
cd $HOME
cd tracker/subscriber/postback
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.subscriber.tracker.postback
chmod 777 *
#----Delayed
cd $HOME
cd tracker/subscriber/delayed
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.subscriber.tracker.delayed.postback
chmod 777 *
#----Filtered
cd $HOME
cd tracker/subscriber/filtered
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.subscriber.tracker.filtered
chmod 777 *
#----subscriber
cd $HOME
cd tracker/subscriber/postback_ping
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.subscriber.tracker.postback.ping
chmod 777 *
#---API
#---POSTBACK
cd $HOME
cd tracker/api/postback
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.api.tracker.postback
chmod 777 *
#---SERVICE-POSTBACK
cd $HOME
cd tracker/services/postback
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.srv.tracker.postback
chmod 777 *
#---SERVICE-POSTBACK-OFFER-MEDIA
cd $HOME
cd tracker/services/postbackoffermedia
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.srv.tracker.postbackoffermedia
chmod 777 *
#--START deployment
#start micro in 10 ports to distribute loads
cd $HOME
cd tracker/micro
nohup ./micro --api_address=0.0.0.0:8000 --selector=cache --client_pool_size=100 --client_request_timeout=4m api  > nohup.out &
nohup ./micro --api_address=0.0.0.0:8001 --selector=cache --client_pool_size=100 --client_request_timeout=4m api  > nohup.out &
nohup ./micro --api_address=0.0.0.0:8002 --selector=cache --client_pool_size=100 --client_request_timeout=4m api  > nohup.out &
#start Freegeoip in 5 ports
cd $HOME
cd tracker/ip-server
nohup ./freegeoip -http localhost:5000  > nohup.out &
nohup ./freegeoip -http localhost:5001  > nohup.out &
nohup ./freegeoip -http localhost:5002  > nohup.out &
#start subscribers
cd $HOME
cd tracker/subscriber/postback
nohup ./$DEPLOY_VERSION.subscriber.tracker.postback > nohup.out &
cd $HOME
cd tracker/subscriber/delayed
nohup ./$DEPLOY_VERSION.subscriber.tracker.delayed.postback > nohup.out &
cd $HOME
cd tracker/subscriber/filtered
nohup ./$DEPLOY_VERSION.subscriber.tracker.filtered > nohup.out &
cd $HOME
cd tracker/subscriber/postback_ping
nohup ./$DEPLOY_VERSION.subscriber.tracker.postback.ping > nohup.out &
#start brokers
cd $HOME
cd tracker/broker/exception
nohup ./$DEPLOY_VERSION.broker.tracker.exception --broker=googlepubsub --selector=cache --client_request_timeout=4m --client_pool_size=100 > nohup.out &
#api
cd $HOME
cd tracker/api/postback
nohup ./$DEPLOY_VERSION.api.tracker.postback  --broker=googlepubsub --selector=cache --client_request_timeout=4m --client_pool_size=100 > nohup.out &
nohup ./$DEPLOY_VERSION.api.tracker.postback  --broker=googlepubsub --selector=cache --client_request_timeout=4m --client_pool_size=100 > nohup.out &
nohup ./$DEPLOY_VERSION.api.tracker.postback  --broker=googlepubsub --selector=cache --client_request_timeout=4m --client_pool_size=100 > nohup.out &
#service
cd $HOME
cd tracker/services/postback
nohup ./$DEPLOY_VERSION.srv.tracker.postback --broker=googlepubsub --selector=cache --client_request_timeout=4m --client_pool_size=100 > nohup.out &
nohup ./$DEPLOY_VERSION.srv.tracker.postback --broker=googlepubsub --selector=cache --client_request_timeout=4m --client_pool_size=100 > nohup.out &
cd $HOME
cd tracker/services/postbackoffermedia
nohup ./$DEPLOY_VERSION.srv.tracker.postbackoffermedia --broker=googlepubsub --selector=cache --client_request_timeout=4m --client_pool_size=100 > nohup.out &
nohup ./$DEPLOY_VERSION.srv.tracker.postbackoffermedia --broker=googlepubsub --selector=cache --client_request_timeout=4m --client_pool_size=100 > nohup.out &
nohup ./$DEPLOY_VERSION.srv.tracker.postbackoffermedia --broker=googlepubsub --selector=cache --client_request_timeout=4m --client_pool_size=100 > nohup.out &
