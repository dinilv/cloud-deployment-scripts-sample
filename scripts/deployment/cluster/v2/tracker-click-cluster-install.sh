#!/bin/bash
#resolve ip address of instance
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
HOST=$(hostname)
HOME="/var"
echo "My public IP & bind IP address: $public_ip - $bind_ip"
DEPLOY_VERSION="v2"

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
    curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip="$bind_ip"&public_ip="$public_ip"&event=pkg_init&module=consul&env=prod&server_type=tracker_click&status=success&host=$HOST"
    #redis warnings
    sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled
    sudo sysctl -w net.core.somaxconn=80000
    sudo sysctl -w fs.file-max=80000
    sudo sysctl -w vm.max_map_count=262144
    sudo ulimit -n 1048576
    #restart redis
    sudo service redis-server restart
    #remove existing applciation
    rm -rf $HOME/tracker
else
    #add for redis warnings
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
    #install redis
    sudo add-apt-repository ppa:chris-lea/redis-server
    sudo apt-get update
    sudo apt-get -y install redis-server --allow-unauthenticated
    #copy new settings for redis-slave
    sudo /bin/sh -c '(echo "slaveof 10.140.0.2 6378" ; cat file1) >> /etc/redis/redis.conf'
    #sudo /bin/sh -c '(echo "requirepass server@123" ; cat file1) >> /etc/redis/redis.conf'
    sudo /bin/sh -c '(echo "masterauth server@123" ; cat file1) >> /etc/redis/redis.conf'
    #ping cluster log for redis replication
    curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip=$bind_ip&public_ip=$public_ip&event=redis_init&module=redis&env=prod&server_type=tracker_click&host=$HOST"
    #restart redis
    sudo service redis-server restart
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
    curl -l "http://0.0.0.0:8080/cluster/node/start?bind_ip="$bind_ip"&public_ip="$public_ip"&event=server_init&module=consul&env=prod&server_type=tracker_click&status=success&host=$HOST"
    #create scripts folder
    mkdir -p $HOME/scripts/logs
    #download scripts
    cd $HOME/scripts
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-click-disk-space.sh
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-click-free-memory.sh
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-click-system-keeper.sh
    wget https://storage.g.tracker/$DEPLOY_VERSION/tracker-click-error-scanner.sh
    chmod 777 *
    #add system keeper to crontab
    touch mycron.txt
    sudo crontab -l > mycron.txt
    sudo crontab -l | { cat; echo "0 */2 * * * $HOME/scripts/tracker-click-error-scanner.sh"; } | crontab -
    sudo crontab -l | { cat; echo "0 */2 * * * $HOME/scripts/tracker-click-system-keeper.sh"; } | crontab -
    sudo crontab -l | { cat; echo "0 */4 * * * $HOME/scripts/tracker-click-free-memory.sh"; } | crontab -
    sudo crontab -l | { cat; echo "0 */6 * * * $HOME/scripts/tracker-click-disk-space.sh"; } | crontab -
    #add ssh keys to known hosts
    ssh 35.198.238.11
    ssh 35.201.178.73
    #shutdown & restart
    sudo reboot
fi
#create app file directory
cd $HOME
mkdir -p tracker/micro tracker/ip-server tracker/api/click
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
#---API
#---CLICK
cd $HOME
cd tracker/api/click
wget https://storage.g.tracker/$DEPLOY_VERSION/click
chmod 777 *
#--START deployment
#start micro in 3 ports to distribute loads
cd $HOME
cd tracker/micro
nohup ./micro --api_address=0.0.0.0:8000 --selector=cache --client_pool_size=1000 api > nohup.out &
nohup ./micro --api_address=0.0.0.0:8001 --selector=cache --client_pool_size=1000 api > nohup.out &
nohup ./micro --api_address=0.0.0.0:8002 --selector=cache --client_pool_size=1000 api > nohup.out &
#start freegeoip in 3 ports
cd $HOME
cd tracker/ip-server
#for click requests
nohup ./freegeoip -http localhost:5000  > nohup.out &
nohup ./freegeoip -http localhost:5001  > nohup.out &
nohup ./freegeoip -http localhost:5002  > nohup.out &
#for click subscribers
nohup ./freegeoip -http localhost:6000  > nohup.out &
nohup ./freegeoip -http localhost:6001  > nohup.out &
nohup ./freegeoip -http localhost:6002  > nohup.out &
#click api
cd $HOME
cd tracker/api/click
nohup ./click --selector=cache --broker=googlepubsub --client_pool_size=1000 > nohup.out &
nohup ./click --selector=cache --broker=googlepubsub --client_pool_size=1000 > nohup.out &
nohup ./click --selector=cache --broker=googlepubsub --client_pool_size=1000 > nohup.out &
