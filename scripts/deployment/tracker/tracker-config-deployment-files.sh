#!/bin/bash
#get version from config app
HOST=$(hostname)
VERSION=$(curl -s 0.0.0.0:8080/deployment/version?server_type=tracker-app&host=$HOST)
CONSUL_PATH="/home/adcamie/platform/consul"
GO_PATH="/home/adcamie/go"
UI_PATH="/home/adcamie/code/ui/ad-tracker-ui/"
GRUNT="/usr/local/bin/grunt"
SERVER="/usr/local/bin/http-server"
GO="/home/adcamie/.go/bin/go"
GIT="/usr/lib/git-core/git"
#reset for local changes
$GIT reset --hard
#stop consul
consul_pid=$(ps -ef | grep consul | grep -v grep | awk '{print $2}')
kill -9 $consul_pid
#remove data directory
rm -rf /tmp/consul
mkdir /tmp/consul
#start consul
cd $CONSUL_PATH
./consul agent -bootstrap -server -data-dir=/tmp/consul -ui -bind=0.0.0.0 -client=0.0.0.0 &
#navigate micro
rm $GO_PATH/bin/micro
cd $GO_PATH/src/github.com/micro/micro
#$GIT pull origin master
$GO install
#latest adcamie code
cd $GO_PATH/src/github.com/adcamie/adserver
#$GIT pull origin master
#log api
rm $GO_PATH/bin/v$VERSION.api.tracker.log
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.log
$GO install
#report api
rm $GO_PATH/bin/v$VERSION.api.tracker.report
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.report
$GO install
#setting api
rm $GO_PATH/bin/v$VERSION.api.tracker.setting
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.setting
$GO install
#decision engine api
rm $GO_PATH/bin/v$VERSION.api.tracker.decision.engine
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.decision.engine
$GO install
#postback api
rm $GO_PATH/bin/v$VERSION.api.tracker.postback
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.postback
$GO install
#log service
rm $GO_PATH/bin/v$VERSION.srv.tracker.log
cd $GO_PATH/src/github.com/adcamie/adserver/service/v$VERSION.srv.tracker.log
$GO install
#report service
rm $GO_PATH/bin/v$VERSION.srv.tracker.report
cd $GO_PATH/src/github.com/adcamie/adserver/service/v$VERSION.srv.tracker.report
$GO install
#setting service
rm $GO_PATH/bin/v$VERSION.srv.tracker.setting
cd $GO_PATH/src/github.com/adcamie/adserver/service/v$VERSION.srv.tracker.setting
$GO install
#decision engine service
rm $GO_PATH/bin/v$VERSION.srv.tracker.decision.engine
cd $GO_PATH/src/github.com/adcamie/adserver/service/v$VERSION.srv.tracker.decision.engine
$GO install
#postback service
rm $GO_PATH/bin/v$VERSION.srv.tracker.postback
cd $GO_PATH/src/github.com/adcamie/adserver/service/v$VERSION.srv.tracker.postback
$GO install
#router file
rm $GO_PATH/bin/report_file
cd $GO_PATH/src/github.com/adcamie/adserver/router/report_file
$GO install
#stop micro
micro_pid=$(ps -ef | grep micro | grep -v grep | awk '{print $2}')
kill -9 $micro_pid
#stop api
log_api_pid=$(ps -ef | grep api.tracker.log | grep -v grep | awk '{print $2}')
report_api_pid=$(ps -ef | grep api.tracker.report | grep -v grep | awk '{print $2}')
setting_api_pid=$(ps -ef | grep api.tracker.setting | grep -v grep | awk '{print $2}')
decision_api_pid=$(ps -ef | grep api.tracker.decision.engine | grep -v grep | awk '{print $2}')
file_pid=$(ps -ef | grep report_file | grep -v grep | awk '{print $2}')
postback_api_pid=$(ps -ef | grep api.tracker.postback | grep -v grep | awk '{print $2}')
kill -9 $log_api_pid $report_api_pid $setting_api_pid $decision_api_pid $file_pid $postback_api_pid
#stop service
log_srv_pid=$(ps -ef | grep srv.tracker.log | grep -v grep | awk '{print $2}')
report_srv_pid=$(ps -ef | grep srv.tracker.report | grep -v grep | awk '{print $2}')
setting_srv_pid=$(ps -ef | grep srv.tracker.setting | grep -v grep | awk '{print $2}')
decision_srv_pid=$(ps -ef | grep srv.tracker.decision.engine | grep -v grep | awk '{print $2}')
postback_srv_pid=$(ps -ef | grep srv.tracker.postback | grep -v grep | awk '{print $2}')
kill -9 $log_srv_pid $report_srv_pid $setting_srv_pid $decision_srv_pid $postback_srv_pid
#create config app directory
cd $GO_PATH/bin
rm -rf tracker-config
mkdir -p tracker-config/micro tracker-config/file tracker-config/api tracker-config/service tracker-config/jobs tracker-config/reports/reports
#mv all files to directory
mv micro tracker-config/micro
mv report_file tracker-config/file
mv v$VERSION.api.tracker.log v$VERSION.api.tracker.report v$VERSION.api.tracker.setting v$VERSION.api.tracker.decision.engine v$VERSION.api.tracker.postback tracker-config/api
mv v$VERSION.srv.tracker.log v$VERSION.srv.tracker.report v$VERSION.srv.tracker.setting v$VERSION.srv.tracker.decision.engine v$VERSION.srv.tracker.postback tracker-config/service
#start all api
cd tracker-config/micro
nohup ./micro --api_address=0.0.0.0:8000 --selector=cache --client_pool_size=100 --client_request_timeout=25m api > nohup.out &
cd ../file
nohup ./report_file > nohup.out &
cd ../api
nohup ./v$VERSION.api.tracker.log --selector=cache --client_pool_size=100 --client_request_timeout=25m > nohup.out &
nohup ./v$VERSION.api.tracker.setting --selector=cache --client_pool_size=100 --client_request_timeout=25m > nohup.out &
nohup ./v$VERSION.api.tracker.report --selector=cache --client_pool_size=100 --client_request_timeout=25m > nohup.out &
nohup ./v$VERSION.api.tracker.decision.engine --selector=cache --client_pool_size=100 --client_request_timeout=10m > nohup.out &
nohup ./v$VERSION.api.tracker.postback  --broker=googlepubsub --selector=cache --client_pool_size=100 --client_request_timeout=10m > nohup.out &
#start all service
cd ../service
nohup ./v$VERSION.srv.tracker.log > nohup.out &
nohup ./v$VERSION.srv.tracker.setting > nohup.out &
nohup ./v$VERSION.srv.tracker.report --client_request_timeout=25m > nohup.out &
nohup ./v$VERSION.srv.tracker.decision.engine > nohup.out &
nohup ./v$VERSION.srv.tracker.postback --broker=googlepubsub --client_request_timeout=10m > nohup.out &
#stop ui
ui_pid=$(ps -ef | grep http-server | grep -v grep | awk '{print $2}')
kill -9 $ui_pid
#remove ui
cd $UI_PATH
rm -rf angular
$GIT pull origin master
#build ui
$GRUNT build:angular
#start ui
cd angular
nohup $SERVER -p 8082 &
