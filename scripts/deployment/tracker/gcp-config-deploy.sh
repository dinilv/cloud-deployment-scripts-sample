#!/bin/bash
HOST=$(hostname)
GIT="/usr/lib/git-core/git"
#compile
cd $GO_PATH/src/github.com/adcamie/gcp-scripts
$GIT reset --hard
$GIT pull origin master
$GO install
#install
cd $GO_PATH/bin
rm -rf gcp
mv gcp-scripts gcp
#stop previous process
pid=$(lsof -n -i :8080 | grep LISTEN | awk '{print $2}')
kill -9 $pid
#start
cd gcp
chmod 777 *
nohup ./gcp-scripts &
