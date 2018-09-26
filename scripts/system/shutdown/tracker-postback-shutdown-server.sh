#!/bin/bash
#call subscriber server to process last messages received
curl -l "http://localhost:6000/subscriber/postback"
curl -l "http://localhost:6001/subscriber/delayed_postback"
curl -l "http://localhost:7001/subscriber/postback-ping"
curl -l "http://localhost:8000/aff_lsr?offer_id=101&aff_id=100"
curl -l "http://localhost:8000/aff_lsr?offer_id=100&aff_id=100"
curl -l "http://localhost:8000/aff_lsr?offer_id=100&aff_id=100"
curl -l "http://localhost:8000/aff_lsr?offer_id=100&aff_id=100"
curl -l "http://localhost:8000/aff_lsr?offer_id=100&aff_id=100"
#resolve ip address of instance
HOST=$(hostname)
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
curl -l "http://0.0.0.0:8080/cluster/node/stop?bind_ip="$bind_ip"&public_ip="$public_ip"&event=server_stop&module=api_micro&env=prod&server_type=tracker_postback&status=success&host=$HOST"
#execute log uploading
sudo /bin/bash /var/scripts/tracker-postback-error-scanner.sh
# push logs for storage
curl -F "file=@$HOME/platform/consul/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=consul" -F "module=consul" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/micro/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=micro" -F "module=micro" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/ip-server/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=freegeoip" -F "module=freegeoip" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/api/postback/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=api_postback" -F "module=api_postback" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/services/postback/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=service_postback" -F "module=service_postback" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/services/postbackoffermedia/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=service_postbackoffermedia" -F "module=service_postbackoffermedia" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/postback/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_postback" -F "module=subscriber_postback" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/filtered/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_filtered" -F "module=subscriber_filtered" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/delayed/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_delayed" -F "module=subscriber_delayed" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
curl -F "file=@$HOME/tracker/subscriber/postback_ping/nohup.out;" -F "server_type=tracker_postback" -F "public_ip=$public_ip" -F "bind_ip=$bind_ip" -F "event=subscriber_postback_ping" -F "module=subscriber_postback_ping" -F "env=prod" -F "file_name=nohup.out" -F "host=$HOST" http://0.0.0.0:8080/cluster/node/health
