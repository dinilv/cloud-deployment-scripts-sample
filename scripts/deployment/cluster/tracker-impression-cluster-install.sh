#!/bin/bash
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/var"
echo "My public IP & bind IP address: $public_ip - $bind_ip"
DEPLOY_VERSION="v"$(curl -s http://0.0.0.0:8080/deployment/version?server_type=tracker_impression&host=$HOST)
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
    curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip="$bind_ip"&public_ip="$public_ip"&event=pkg_init&module=consul&env=prod&server_type=tracker_impression&status=success&host=$HOST"
    #ping for server event
    curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip=$bind_ip&public_ip=$public_ip&event=server_start&module=app&env=prod&server_type=tracker_impression&host=$HOST"
    #remove existing applciation
    rm -rf $HOME/tracker
    #file issues
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
    wget https://releases.hashicorp.com/consul/1.0.0/consul_1.0.0_linux_amd64.zip?_ga=2.227024861.157401582.1509380164-2128507747.1506420902
    mv consul_1.0.0_linux_amd64.zip?_ga=2.227024861.157401582.1509380164-2128507747.1506420902 consul.zip
    unzip consul.zip
    rm consul.zip
    #start consul
    chmod 777 consul
    ./consul agent -bootstrap -server -data-dir=$HOME/platform/consul/data -ui -bind=0.0.0.0 -client=0.0.0.0 > nohup.out &
    #ping cluster listner
    curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip="$bind_ip"&public_ip="$public_ip"&event=server_init&module=consul&env=prod&server_type=tracker_impression&status=success&host=$HOST"
    #ping cluster to initiate server
    curl -l "http://0.0.0.0:8080/cluster/node/add?bind_ip="$bind_ip"&public_ip="$public_ip"&server_type=tracker_impression&host=$HOST"
    #create scripts folder
    mkdir -p $HOME/scripts/logs
    #download scripts
    cd $HOME/scripts
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-app-disk-space.sh
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-app-free-memory.sh
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-app-system-keeper.sh
    chmod 777 *
    #add system keeper to crontab
    touch mycron.txt
    sudo crontab -l > mycron.txt
    sudo crontab -l | { cat; echo "0 */4 * * * $HOME/scripts/tracker-app-system-keeper.sh"; } | crontab -
    #add disk check script to crontab
    sudo crontab -l | { cat; echo "0 */4 * * * $HOME/scripts/tracker-app-free-memory.sh"; } | crontab -
    #add memory check script to crontab
    sudo crontab -l | { cat; echo "0 */6 * * * $HOME/scripts/tracker-app-disk-space.sh"; } | crontab -
    #add ssh keys to known hosts
    ssh 35.198.238.11
    ssh 35.201.178.73
    #shutdown & restart
    sudo reboot
fi
#create app file directory
cd $HOME
mkdir -p tracker/micro tracker/ip-server tracker/api/impression
mkdir -p tracker/broker/impression
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
#---IMPRESSION
cd $HOME
cd tracker/broker/impression
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.broker.tracker.impression
chmod 777 *
#---API
#---IMPRESSION
cd $HOME
cd tracker/api/impression
wget https://storage.g.tracker/$DEPLOY_VERSION/$DEPLOY_VERSION.api.tracker.impression
chmod 777 *
#--START deployment
#start micro in 10 ports to distribute loads
cd $HOME
cd tracker/micro
nohup ./micro --api_address=0.0.0.0:8000 --selector=cache --client_pool_size=100 --client_request_timeout=1m api  > nohup.out &
nohup ./micro --api_address=0.0.0.0:8001 --selector=cache --client_pool_size=100 --client_request_timeout=1m api  > nohup.out &
nohup ./micro --api_address=0.0.0.0:8002 --selector=cache --client_pool_size=100 --client_request_timeout=1m api  > nohup.out &
nohup ./micro --api_address=0.0.0.0:8003 --selector=cache --client_pool_size=100 --client_request_timeout=1m api  > nohup.out &
nohup ./micro --api_address=0.0.0.0:8004 --selector=cache --client_pool_size=100 --client_request_timeout=1m api  > nohup.out &
#start Freegeoip in 5 ports
cd $HOME
cd tracker/ip-server
nohup ./freegeoip -http localhost:5000  > nohup.out &
nohup ./freegeoip -http localhost:5001  > nohup.out &
nohup ./freegeoip -http localhost:5002  > nohup.out &
nohup ./freegeoip -http localhost:5003  > nohup.out &
nohup ./freegeoip -http localhost:5004  > nohup.out &
#start api
cd $HOME
cd tracker/api/impression
nohup ./$DEPLOY_VERSION.api.tracker.impression  --broker=googlepubsub --selector=cache --client_pool_size=100 > nohup.out &
nohup ./$DEPLOY_VERSION.api.tracker.impression  --broker=googlepubsub --selector=cache --client_pool_size=100 > nohup.out &
nohup ./$DEPLOY_VERSION.api.tracker.impression  --broker=googlepubsub --selector=cache --client_pool_size=100 > nohup.out &
nohup ./$DEPLOY_VERSION.api.tracker.impression  --broker=googlepubsub --selector=cache --client_pool_size=100 > nohup.out &
nohup ./$DEPLOY_VERSION.api.tracker.impression  --broker=googlepubsub --selector=cache --client_pool_size=100 > nohup.out &
#start brokers
cd $HOME
cd tracker/broker/impression
nohup ./$DEPLOY_VERSION.broker.tracker.impression --broker=googlepubsub > nohup.out &
