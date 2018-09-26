#!/bin/bash
HOST=$(hostname)
#get version from config app
VERSION=$(curl -s 0.0.0.0:8080/deployment/version?server_type=tracker_subscribers&host=$HOST)
GO_PATH="/home/adcamie/go"
GO="/home/adcamie/.go/bin/go"
GIT="/usr/lib/git-core/git"

#ping each port of subscribers for shutdown
curl -l localhost:7032/subscriber/delayed-sub/shutdown
curl -l localhost:7025/subscriber/delayed-postback/shutdown
curl -l localhost:7024/subscriber/filtered/shutdown
curl -l localhost:7023/subscriber/postback-ping/shutdown
curl -l localhost:7022/subscriber/postback/shutdown
curl -l "track.adcamie.com/aff_lsr?offer_id=96&aff_id=96"
curl -l localhost:7021/subscriber/rotated/shutdown
curl -l localhost:7020/subscriber/click/shutdown
curl -l localhost:7019/subscriber/click/shutdown
curl -l localhost:7018/subscriber/click/shutdown
curl -l localhost:7017/subscriber/click/shutdown
curl -l localhost:7016/subscriber/click/shutdown
curl -l localhost:7015/subscriber/click/shutdown
curl -l localhost:7014/subscriber/click/shutdown
curl -l localhost:7013/subscriber/click/shutdown
curl -l localhost:7012/subscriber/click/shutdown
curl -l localhost:7011/subscriber/click/shutdown
curl -l localhost:7010/subscriber/click/shutdown

#remove existing freegeoip
rm $GO_PATH/bin/freegeoip
cd $GO_PATH/src/github.com/fiorix/freegeoip/cmd/freegeoip
#get freegeopip
$GIT pull origin master
$GO install github.com/fiorix/freegeoip/cmd/freegeoip

#pull latest
cd $GO_PATH/src/github.com/adcamie/adserver

#reset for local changes
$GIT reset --hard
$GIT pull origin master

#remove deployment folder
rm -rf $GO_PATH/bin/tracker-subscribers

#compile and install each subscribers
#impression
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.impression
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.impression
$GO install
#banner-click
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.banner.click
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.banner.click
$GO install
#landing-page
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.landing.page
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.landing.page
$GO install
#click
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.click
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.click
$GO install
#rotated
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.rotated
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.rotated
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
#content-view
rm $GO_PATH/bin/v$VERSION.subscriber.tracker.content.view
cd $GO_PATH/src/github.com/adcamie/adserver/subscriber/v$VERSION.subscriber.tracker.content.view
$GO install

#create directory structure
cd $GO_PATH/bin
mkdir -p tracker-subscribers/freegeoip tracker-subscribers/click tracker-subscribers/postback
mkdir -p tracker-subscribers/postback-ping tracker-subscribers/rotated
mkdir -p tracker-subscribers/filtered tracker-subscribers/delayed-postback

#move freegeoip
cd $GO_PATH/bin
mv freegeoip tracker-subscribers/freegeoip
cd tracker-subscribers/freegeoip
chmod 777 *
#start freegeoip
nohup ./freegeoip -http localhost:5000 &
nohup ./freegeoip -http localhost:5001 &
nohup ./freegeoip -http localhost:6000 &
nohup ./freegeoip -http localhost:6001 &
nohup ./freegeoip -http localhost:6002 &
nohup ./freegeoip -http localhost:6003 &

#move subscriber package to corresponding folders
#click
mv v$VERSION.subscriber.tracker.click tracker-subscribers/click
cd tracker-subscribers/click
chmod 777 *
cd $GO_PATH/bin
#postback
mv v$VERSION.subscriber.tracker.postback tracker-subscribers/postback
cd tracker-subscribers/postback
chmod 777 *
cd $GO_PATH/bin
#postback-ping
mv v$VERSION.subscriber.tracker.postback.ping tracker-subscribers/postback-ping
cd tracker-subscribers/postback-ping
chmod 777 *
cd $GO_PATH/bin
#rotated
mv v$VERSION.subscriber.tracker.rotated tracker-subscribers/rotated
cd tracker-subscribers/rotated
chmod 777 *
cd $GO_PATH/bin
#filtered
mv v$VERSION.subscriber.tracker.filtered tracker-subscribers/filtered
cd tracker-subscribers/filtered
chmod 777 *
cd $GO_PATH/bin
#delayed-postback
mv v$VERSION.subscriber.tracker.delayed.postback tracker-subscribers/delayed-postback
cd tracker-subscribers/delayed-postback
chmod 777 *
cd $GO_PATH/bin
#find each process by port
pid_7010=$(lsof -n -i :7010 | grep LISTEN | awk '{print $2}')
pid_7011=$(lsof -n -i :7011 | grep LISTEN | awk '{print $2}')
pid_7012=$(lsof -n -i :7012 | grep LISTEN | awk '{print $2}')
pid_7013=$(lsof -n -i :7013 | grep LISTEN | awk '{print $2}')
pid_7014=$(lsof -n -i :7014 | grep LISTEN | awk '{print $2}')
pid_7015=$(lsof -n -i :7015 | grep LISTEN | awk '{print $2}')
pid_7016=$(lsof -n -i :7016 | grep LISTEN | awk '{print $2}')
pid_7017=$(lsof -n -i :7017 | grep LISTEN | awk '{print $2}')
pid_7018=$(lsof -n -i :7018 | grep LISTEN | awk '{print $2}')
pid_7019=$(lsof -n -i :7019 | grep LISTEN | awk '{print $2}')
pid_7020=$(lsof -n -i :7020 | grep LISTEN | awk '{print $2}')
pid_7021=$(lsof -n -i :7021 | grep LISTEN | awk '{print $2}')
pid_7022=$(lsof -n -i :7022 | grep LISTEN | awk '{print $2}')
pid_7023=$(lsof -n -i :7022 | grep LISTEN | awk '{print $2}')
pid_7024=$(lsof -n -i :7022 | grep LISTEN | awk '{print $2}')
#stop by PID
kill -9 $pid_7010 $pid_7011 $pid_7012 $pid_7013 $pid_7014 $pid_7015 $pid_7016
kill -9 $pid_7017 $pid_7018 $pid_7019 $pid_7020 $pid_7021 $pid_7022 $pid_7023
kill -9 $pid_7024

#start with port numbers
#click
cd $GO_PATH/bin
cd tracker-subscribers/click
nohup ./v1.subscriber.tracker.click 7010 &
nohup ./v1.subscriber.tracker.click 7011 &
nohup ./v1.subscriber.tracker.click 7012 &
nohup ./v1.subscriber.tracker.click 7013 &
nohup ./v1.subscriber.tracker.click 7014 &
nohup ./v1.subscriber.tracker.click 7015 &
nohup ./v1.subscriber.tracker.click 7016 &
nohup ./v1.subscriber.tracker.click 7017 &
nohup ./v1.subscriber.tracker.click 7018 &
nohup ./v1.subscriber.tracker.click 7019 &
nohup ./v1.subscriber.tracker.click 7020 &
#rotated
cd $GO_PATH/bin
cd tracker-subscribers/rotated
nohup ./v1.subscriber.tracker.rotated 7021 &
#postback
cd $GO_PATH/bin
cd tracker-subscribers/postback
nohup ./v1.subscriber.tracker.postback 7022 &
#postback-ping
cd $GO_PATH/bin
cd tracker-subscribers/postback-ping
nohup ./v1.subscriber.tracker.postback.ping 7023 &
#filtered
cd $GO_PATH/bin
cd tracker-subscribers/filtered
nohup ./v1.subscriber.tracker.filtered 7024 &
#delayed-postback
cd $GO_PATH/bin
cd tracker-subscribers/delayed-postback
nohup ./v1.subscriber.tracker.delayed.postback 7025 &
