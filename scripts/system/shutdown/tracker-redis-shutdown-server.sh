#!/bin/bash
#resolve ip address of instance
HOST=$(hostname)
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
curl -l "http://0.0.0.0:8080/cluster/node/stop?bind_ip="$bind_ip"&public_ip="$public_ip"&event=server_stop&module=redis&env=prod&server_type=tracker_db_cluster&status=success&host=$HOST"
