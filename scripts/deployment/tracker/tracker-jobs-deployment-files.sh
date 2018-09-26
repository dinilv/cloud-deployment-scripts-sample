#!/bin/bash
HOST=$(hostname)
#get version from config app
VERSION=$(curl -s 0.0.0.0:8080/deployment/version?server_type=tracker_jobs&host=$HOST)
GO_PATH="/home/adcamie/go"
GO="/home/adcamie/.go/bin/go"
GIT="/usr/lib/git-core/git"

#reset for local changes
$GIT reset --hard

#pull latest
cd $GO_PATH/src/github.com/adcamie/adserver
$GIT pull origin master

#remove deployment folder
rm -rf $GO_PATH/bin/tracker-jobs

#remove existing job files if exists
rm $GO_PATH/bin/alert $GO_PATH/bin/big_query_upload $GO_PATH/bin/check_postback $GO_PATH/bin/delete_mongo_data
rm $GO_PATH/bin/redirection_check $GO_PATH/bin/report_mongo
rm $GO_PATH/bin/retry_filtered_postback $GO_PATH/bin/subscription_alert $GO_PATH/bin/upload_email_report

#compile all jobs
cd $GO_PATH/src/github.com/adcamie/adserver/jobs/alert
$GO install
cd $GO_PATH/src/github.com/adcamie/adserver/jobs/big_query_upload
$GO install
cd $GO_PATH/src/github.com/adcamie/adserver/jobs/check_postback
$GO install
cd $GO_PATH/src/github.com/adcamie/adserver/jobs/delete_mongo_data
$GO install
cd $GO_PATH/src/github.com/adcamie/adserver/jobs/redirection_check
$GO install
cd $GO_PATH/src/github.com/adcamie/adserver/jobs/report_mongo
$GO install
cd $GO_PATH/src/github.com/adcamie/adserver/jobs/retry_filtered_postback
$GO install
cd $GO_PATH/src/github.com/adcamie/adserver/jobs/subscription_alert
$GO install
cd $GO_PATH/src/github.com/adcamie/adserver/jobs/upload_email_report
$GO install

#find pids
alert_pid=$(ps -ef | grep alert | grep -v grep | awk '{print $2}')
big_query_upload_pid=$(ps -ef | grep big_query_upload | grep -v grep | awk '{print $2}')
check_postback_pid=$(ps -ef | grep check_postback | grep -v grep | awk '{print $2}')
delete_mongo_data_pid=$(ps -ef | grep delete_mongo_data | grep -v grep | awk '{print $2}')
redirection_check_pid=$(ps -ef | grep redirection_check | grep -v grep | awk '{print $2}')
report_mongo_pid=$(ps -ef | grep report_mongo | grep -v grep | awk '{print $2}')
retry_filtered_postback_pid=$(ps -ef | grep retry_filtered_postback | grep -v grep | awk '{print $2}')
subscription_alert_pid=$(ps -ef | grep subscription_alert | grep -v grep | awk '{print $2}')
upload_email_report_pid=$(ps -ef | grep upload_email_report | grep -v grep | awk '{print $2}')

#stop all existing process
kill -9 $alert_pid $big_query_upload_pid $check_postback_pid $delete_mongo_data_pid $redirection_check_pid
kill -9 $report_mongo_pid $retry_filtered_postback_pid $subscription_alert_pid $upload_email_report_pid

#create all directories
mkdir -p $GO_PATH/bin/tracker-jobs/alert $GO_PATH/bin/tracker-jobs/big_query_upload $GO_PATH/bin/tracker-jobs/check_postback $GO_PATH/bin/tracker-jobs/delete_mongo_data
mkdir -p $GO_PATH/bin/tracker-jobs/redirection_check $GO_PATH/bin/tracker-jobs/report_mongo
mkdir -p $GO_PATH/bin/tracker-jobs/retry_filtered_postback $GO_PATH/bin/tracker-jobs/subscription_alert $GO_PATH/bin/tracker-jobs/upload_email_report

#move files
cd $GO_PATH/bin
mv alert $GO_PATH/bin/tracker-jobs/alert
mv big_query_upload $GO_PATH/bin/tracker-jobs/big_query_upload
mv check_postback $GO_PATH/bin/tracker-jobs/check_postback
mv delete_mongo_data $GO_PATH/bin/tracker-jobs/delete_mongo_data
mv redirection_check $GO_PATH/bin/tracker-jobs/redirection_check
mv report_mongo $GO_PATH/bin/tracker-jobs/report_mongo
mv retry_filtered_postback $GO_PATH/bin/tracker-jobs/retry_filtered_postback
mv subscription_alert $GO_PATH/bin/tracker-jobs/subscription_alert
mv upload_email_report $GO_PATH/bin/tracker-jobs/upload_email_report

#start all jobs
cd $GO_PATH/bin/tracker-jobs
cd alert
nohup ./alert > nohup.out &
cd ../big_query_upload
nohup ./big_query_upload > nohup.out &
cd ../check_postback
nohup ./check_postback > nohup.out &
cd ../delete_mongo_data
nohup ./delete_mongo_data > nohup.out &
cd ../redirection_check
nohup ./redirection_check > nohup.out &
cd ../report_mongo
nohup ./report_mongo > nohup.out &
cd ../retry_filtered_postback
nohup ./retry_filtered_postback > nohup.out &
cd ../subscription_alert
nohup ./subscription_alert > nohup.out &
cd ../upload_email_report
nohup ./upload_email_report > nohup.out &
