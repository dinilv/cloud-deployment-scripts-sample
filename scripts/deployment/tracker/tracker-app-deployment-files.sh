#!/bin/bash
HOST=$(hostname)
#get version from config app
VERSION=$(curl -s 0.0.0.0:8080/deployment/version?server_type=tracker-app&host=$HOST)
GO_PATH="/home/adcamie/go"
GO="/home/adcamie/.go/bin/go"
GIT="/usr/lib/git-core/git"
#reset for local changes
#cd $GO_PATH/src/github.com/adcamie/adserver/
#$GIT reset --hard
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
#$GIT pull origin master
#impression api
rm $GO_PATH/bin/v$VERSION.api.tracker.impression
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.impression
$GO install
#click api
rm $GO_PATH/bin/v$VERSION.api.tracker.click
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.click
$GO install
#navigate to postback api
rm $GO_PATH/bin/v$VERSION.api.tracker.postback
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.postback
$GO install
#postback service
rm $GO_PATH/bin/v$VERSION.srv.tracker.postback
cd $GO_PATH/src/github.com/adcamie/adserver/service/v$VERSION.srv.tracker.postback
$GO install
#postback media service
rm $GO_PATH/bin/v$VERSION.srv.tracker.postbackoffermedia
cd $GO_PATH/src/github.com/adcamie/adserver/service/v$VERSION.srv.tracker.postbackoffermedia
$GO install
#navigate to brokers
#exception
rm $GO_PATH/bin/v$VERSION.broker.tracker.exception
cd $GO_PATH/src/github.com/adcamie/adserver/broker/v$VERSION.broker.tracker.exception
$GO install
#navigate to subscribers
#impression
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.impression
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.impression
$GO install
#click
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.click
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.click
$GO install
#postback
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.postback
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.postback
$GO install
#postback-ping
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.postback.ping
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.postback.ping
$GO install
#delayed
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.delayed.postback
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.delayed.postback
$GO install
#filtered
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.filtered
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.filtered
$GO install
#rotated
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.rotated
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.rotated
$GO install
