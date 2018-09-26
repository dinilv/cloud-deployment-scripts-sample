#!/bin/bash
cd /var/consul/data
rm -rf *
rm -rf /home/server/code/go/bin/tracker
cd
cd platform
consul agent -config-dir /etc/consul.d/bootstrap --bind 127.0.0.1 &

cd elastic/bin
./elasticsearch &

cd /home/server/code/go/src/github.com/nats-io/gnatsd
go install

#compile data extractor
cd /home/server/code/go/src/github.com/giftedstrings/dataextractor
go install

#compile adserver
cd /home/server/code/go/src/github.com/adcamie/adserver
cd api
cd v1.api.mo.adserve
go install
cd ../v1.api.mo.campaign
go install
cd ../../service/v1.srv.mo.adserve
go install

#compile alerts
cd /home/server/code/go/src/github.com/adcamie/adserver/jobs/
go install

#compile tracker api
cd /home/server/code/go/src/github.com/fiorix/freegeoip/cmd/freegeoip
go install
cd /home/server/code/go/src/github.com/micro/micro
go install
cd /home/server/code/go/src/github.com/adcamie/adserver
cd api/v1.api.tracker.setting
go install
cd ../v1.api.tracker.impression/
go install
cd ../v1.api.tracker.click/
go install
cd ../v1.api.tracker.postback/
go install
cd ../v1.api.tracker.decision.engine/
go install
cd ../v1.api.tracker.log/
go install
cd ../v1.api.tracker.report/
go install
cd ../../broker
go install
cd ../router/file
go install
cd ../track
go install
#compile tracker services
cd ../../service/v1.srv.tracker.setting/
go install
cd ../../service/v1.srv.tracker.postback/
go install
cd ../../service/v1.srv.tracker.postbackoffermedia/
go install
cd ../../service/v1.srv.tracker.log/
go install
cd ../../service/v1.srv.tracker.report/
go install
cd ../../service/v1.srv.tracker.decision.engine/
go install

#start tor & data extractor
cd /home/server/code/go/bin/
mkdir gpdataextractor
mv datextractor gpdataextractor
cd gpdatextractor
nohup ./dataextractor &
nohup ./jobs &

#start micro api & services
cd /home/server/code/go/bin/
./gnatsd -m 8222 &
rm -rf tracker
mkdir -p tracker/ip tracker/micro tracker/api tracker/services tracker/server
mv freegeoip tracker/ip
mv micro tracker/micro
mv v1.api.tracker.setting v1.api.tracker.impression v1.api.tracker.click v1.api.tracker.postback v1.api.tracker.decision.engine v1.api.tracker.log v1.api.tracker.report tracker/api
mv v1.srv.tracker.setting v1.srv.tracker.postback v1.srv.tracker.log v1.srv.tracker.report v1.srv.tracker.decision.engine v1.srv.tracker.postbackoffermedia tracker/services
mv file track broker tracker/server
cd tracker
mkdir reports
cd ip
nohup ./freegeoip -http localhost:5000 &
cd ../micro
nohup ./micro --api_address=0.0.0.0:8000 --selector=cache --client_pool_size=10000 api &
nohup ./micro --api_address=0.0.0.0:8001 --selector=cache --client_pool_size=100000 api &
nohup ./micro --api_address=0.0.0.0:8002 --selector=cache --client_pool_size=10000 --client_request_timeout=4m api &
nohup ./micro --api_address=0.0.0.0:8003 --client_request_timeout=30m api &
cd ../api
nohup ./v1.api.tracker.setting --client_request_timeout=5m &
#start 5 imp, 10 click & 5 postback
nohup ./v1.api.tracker.impression --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.impression --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.impression --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.impression --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.impression --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &

nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &
nohup ./v1.api.tracker.click --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=1000 &

nohup ./v1.api.tracker.postback --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=10 --client_request_timeout=4m &
nohup ./v1.api.tracker.postback --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=10 --client_request_timeout=4m &
nohup ./v1.api.tracker.postback --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=10 --client_request_timeout=4m &
nohup ./v1.api.tracker.postback --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=10 --client_request_timeout=4m &
nohup ./v1.api.tracker.postback --broker=nats --broker_address=127.0.0.1:4222 --client_pool_size=10 --client_request_timeout=4m &

nohup ./v1.api.tracker.report --client_request_timeout=25m &
nohup ./v1.api.tracker.log --client_request_timeout=5m &
nohup ./v1.api.tracker.decision.engine --client_request_timeout=5m &
cd ../server
nohup ./broker --broker=nats --broker_address=127.0.0.1:4222 &
nohup ./file &
nohup ./track &
cd ../services
nohup ./v1.srv.tracker.setting &

nohup ./v1.srv.tracker.postback &
nohup ./v1.srv.tracker.postback &
nohup ./v1.srv.tracker.postback &
nohup ./v1.srv.tracker.postback &
nohup ./v1.srv.tracker.postback &

nohup ./v1.srv.tracker.postbackoffermedia &
nohup ./v1.srv.tracker.postbackoffermedia &
nohup ./v1.srv.tracker.postbackoffermedia &


nohup ./v1.srv.tracker.report &
nohup ./v1.srv.tracker.log &
nohup ./v1.srv.tracker.decision.engine &
cd /home/server/code/ui/ad-server-ui
passenger start &
