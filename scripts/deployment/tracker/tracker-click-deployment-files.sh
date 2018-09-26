#!/bin/bash
HOST=$(hostname)
#get version from config app
VERSION=$(curl -s 0.0.0.0:8080/deployment/version?server_type=tracker_click&host=$HOST)
GO_PATH="/home/adcamie/go"
GO="/home/adcamie/.go/bin/go"
GIT="/usr/lib/git-core/git"
#reset for local changes
$GIT reset --hard
#latest adcamie code
cd $GO_PATH/src/github.com/adcamie/adserver
$GIT pull origin master
#click api
rm $GO_PATH/bin/v$VERSION.api.tracker.click
cd $GO_PATH/src/github.com/adcamie/adserver/api/v$VERSION.api.tracker.click
$GO install
#navigate to subscribers
#click
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.click
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.click
$GO install
#rotated
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.rotated
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.rotated
$GO install
#navigate to brokers
#exception
rm $GO_PATH/bin/v$VERSION.broker.tracker.exception
cd $GO_PATH/src/github.com/adcamie/adserver/broker/v$VERSION.broker.tracker.exception
$GO install
