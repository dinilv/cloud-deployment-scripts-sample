#!/bin/bash
HOST=$(hostname)
#get version from config app
VERSION=$(curl -s 0.0.0.0:8080/deployment/version?server_type=tracker_impression&host=$HOST)
GO_PATH="/home/adcamie/go"
GO="/home/adcamie/.go/bin/go"
GIT="/usr/lib/git-core/git"
#reset for local changes
$GIT reset --hard
#remove existing freegeoip
rm $GO_PATH/bin/freegeoip
cd $GO_PATH/src/github.com/fiorix/freegeoip/cmd/freegeoip
#get freegeopip
$GIT pull origin master
$GO install github.com/fiorix/freegeoip/cmd/freegeoip
#navigate micro
rm $GO_PATH/bin/micro
cd $GO_PATH/src/github.com/micro/micro
$GO install
#latest adcamie code
cd $GO_PATH/src/github.com/adcamie/adserver
$GIT pull origin master
#impression api
rm $GO_PATH/bin/v$VERSION.api.tracker.impression
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.impression
$GO install
#navigate to brokers
#impression
rm $GO_PATH/bin/v$VERSION.broker.tracker.impression
cd $GO_PATH/src/github.com/adcamie/adserver/broker/v$VERSION.broker.tracker.impression
$GO install
