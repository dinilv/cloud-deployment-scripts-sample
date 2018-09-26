#!/bin/bash
#call subscriber server to process last messages received
curl -l "http://localhost:6003/subscriber/click"
#resolve ip address of instance
HOST=$(hostname)
public_ip=$(curl -s https://api.ipify.org)
bind_ip=$(dig +short `hostname -f`)
curl -l "http://0.0.0.0:8080/cluster/node/stop?bind_ip="$bind_ip"&public_ip="$public_ip"&event=server_stop&module=api_micro&env=prod&server_type=tracker_click&status=success&host=$HOST"
#execute log uploading
sudo /bin/bash /var/scripts/tracker-click-error-scanner.sh
