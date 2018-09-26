#!/bin/bash
HOST=$(hostname)
#get version from config app
VERSION=$(curl -s 0.0.0.0:8080/deployment/version?server_type=tracker_subscribers&host=$HOST)
GO_PATH="/home/adcamie/go"
GO="/home/adcamie/.go/bin/go"
GIT="/usr/lib/git-core/git"

#ping each port of subscribers for shutdown
curl -l localhost:7032/subscriber/delayed-sub/db
curl -l localhost:7025/subscriber/delayed-postback/db
curl -l localhost:7024/subscriber/filtered/db
curl -l localhost:7023/subscriber/postback-ping/db
curl -l localhost:7022/subscriber/postback/db
curl -l "track.adcamie.com/aff_lsr?offer_id=96&aff_id=96"
curl -l localhost:7021/subscriber/rotated/db
curl -l localhost:7020/subscriber/click/db
curl -l localhost:7019/subscriber/click/db
curl -l localhost:7018/subscriber/click/db
curl -l localhost:7017/subscriber/click/db
curl -l localhost:7016/subscriber/click/db
curl -l localhost:7015/subscriber/click/db
curl -l localhost:7014/subscriber/click/db
curl -l localhost:7013/subscriber/click/db
curl -l localhost:7012/subscriber/click/db
curl -l localhost:7011/subscriber/click/db
curl -l localhost:7010/subscriber/click/db
