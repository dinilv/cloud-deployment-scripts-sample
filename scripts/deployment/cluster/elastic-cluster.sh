#install elastic-search
yes | sudo apt-get install openjdk-8-jre
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0.deb
sudo dpkg -i elasticsearch-6.0.0.deb
sudo systemctl enable elasticsearch.service
ES_DATA_NODE="node.name: data-"$HOST
echo $ES_DATA_NODE > file2
ES_DATA_HOST="network.host: localhost,"$bind_ip
echo $ES_DATA_HOST > file3
#change config file details
sudo /bin/sh -c '(echo "cluster.name: tracker-elastic" ; cat file1) >> /etc/elasticsearch/elasticsearch.yml'
sudo /bin/sh -c '(cat file2) >> /etc/elasticsearch/elasticsearch.yml'
sudo /bin/sh -c '(echo "node.data: true" ; cat file1) >> /etc/elasticsearch/elasticsearch.yml'
sudo /bin/sh -c '(echo "node.master: false" ; cat file1) >> /etc/elasticsearch/elasticsearch.yml'
sudo /bin/sh -c '(cat file3) >> /etc/elasticsearch/elasticsearch.yml'
sudo /bin/sh -c '(echo "discovery.zen.ping.unicast.hosts: ["10.148.0.6"]" ; cat file1) >> /etc/elasticsearch/elasticsearch.yml'
sudo systemctl start elasticsearch
