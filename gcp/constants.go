package gcp

//db related
var DB = "gcp-cluster"
var ClusterLogColl = "ClusterLog"
var DeploymentFileColl = "DeploymentFile"
var DeploymentReqColl = "DeploymentReq"
var GCPServerColl = "GCPServer"
var AlertColl = "Alert"
var SMSColl = "SmsAlert"
var Version = "version"
var DBPublicIP = "publicIP"
var DBServerType = "serverType"
var UTCTime = "utctime"
var Offset = "offset"
var ServerInit = "server_init"

//req variables
var BindIP = "bind_ip"
var PublicIP = "public_ip"
var Details = "details"
var Host = "host"
var ServerType = "server_type" //tracker_db_cluster,tracker_app_cluster,cmp_engine_db_cluster,cmp_engine_app_cluster,tracker_master_cluster
//tracker_click

var Module = "module"   //app,db,mongo,redis,consul,api_micro,api_click,api_impression,api_postback,app_freegeoip,app_subscriber
var Environment = "env" //test,prod
var File = "file"

//events
var Event = "event" //server_init,pkg_init,db_init,server_start,server_stop,disk_check,memory_check,db_alert,app_log_alert,code_error
var DiskCheck = "disk_check"
var MemoryCheck = "memory_check"
var FileName = "file_name"
var FilePath = "filePath"

//status
var Status = "status" //fail,success,received
var Success = "success"
var Fail = "fail"
var Received = "received"

//server types
var TrackerDBCluster = "tracker_db_cluster"
var TrackerAppCluster = "tracker_app_cluster"
var TrackerMasterCluster = "tracker_master_cluster"

//file path
var LogPath = "https://storage.googleapis.com/tracker-logs/"
var Separator = "/"
var AdcamieGOPath = "/home/adcamie/go/bin/"

var HomePath = "/home/adcamie/"

//var HomePath = ""

//deployment files for tracker app
var MICRO = "micro"
var FreeGEOIP = "freegeoip"
var API = "api"
var SERVICES = "services"
var BROKER = "jobs"
var SCRIPTS = "scripts"
var JOBS = "jobs"
var VERSION = "VERSION"

var TrackerCloudStoragePath = map[string]string{
	FreeGEOIP: "tracker-deployment/ip-server/",
	MICRO:     "tracker-deployment/micro/",
	API:       "tracker-deployment/api/",
	SERVICES:  "tracker-deployment/services/",
	BROKER:    "tracker-deployment/broker/",
	SCRIPTS:   "tracker-deployment/scripts/",
	JOBS:      "tracker-deployment/jobs/",
}
var TrackerAPIImpression = "vVERSION.api.tracker.impression"
var TrackerAPIClick = "vVERSION.api.tracker.click"
var TrackerAPIPostback = "vVERSION.api.tracker.postback"
var TrackerServicePostback = "vVERSION.srv.tracker.postback"
var TrackerServicePostbackOfferMedia = "vVERSION.srv.tracker.postbackoffermedia"

//brokers
var TrackerImpressionBroker = "vVERSION.broker.tracker.impression"
var TrackerExceptionBroker = "vVERSION.broker.tracker.exception"
var TrackerClickBroker = "vVERSION.broker.tracker.click"
var TrackerPostbackBroker = "vVERSION.broker.tracker.postback"
var TrackerFilteredBroker = "vVERSION.broker.tracker.filtered"
var TrackerRotatedBroker = "vVERSION.broker.tracker.rotated"
var TrackerDelayedBroker = "vVERSION.broker.tracker.delayed.postback"

//subscribers
var TrackerImpressionSubscriber = "vVERSION.subscriber.tracker.impression"
var TrackerClickSubscriber = "vVERSION.subscriber.tracker.click"
var TrackerPostbackSubscriber = "vVERSION.subscriber.tracker.postback"
var TrackerPostbackPingSubscriber = "vVERSION.subscriber.tracker.postback.ping"
var TrackerFilteredSubscriber = "vVERSION.subscriber.tracker.filtered"
var TrackerRotatedSubscriber = "vVERSION.subscriber.tracker.rotated"
var TrackerDelayedSubscriber = "vVERSION.subscriber.tracker.delayed.postback"

var TrackerRouter = "tracker_router"
var TrackerAlert = "db_alert"
var TrackerBigQueryUpload = "big_query_upload"

//script path
var TrackerAppScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/tracker-app-deployment-files.sh"
var TrackerConfigScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/tracker-config-deployment-files.sh"
var TrackerJobScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/tracker-jobs-deployment-files.sh"
var TrackerImpressionScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/tracker-impression-deployment-files.sh"
var TrackerClickScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/tracker-click-deployment-files.sh"
var TrackerPostbackScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/tracker-postback-deployment-files.sh"
var GCPServerStopScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker-config-stop-server.sh"
var TrackerSystemKeeperPath = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/system/sweeper/"
var TrackerMonitorPath = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/system/monitor/"
var GCPConfigScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/gcp-config-deploy.sh"

//subscribers
var TrackerSubscribersDeployScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/tracker-subscribers-deploy.sh"
var TrackerSubscribersStopScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/tracker-subscribers-stop.sh"
var TrackerSubscribersRestartScript = "/home/adcamie/go/src/github.com/adcamie/gcp-scripts/scripts/deployment/tracker/tracker-subscribers-restart.sh"

var TrackerAppSystemKeeper = "tracker-app-system-keeper.sh"
var TrackerAppDiskSpace = "tracker-app-disk-space.sh"
var TrackerAppMemoryCheck = "tracker-app-free-memory.sh"
var TrackerDBSystemKeeper = "tracker-db-system-keeper.sh"
var TrackerDBDiskSpace = "tracker-db-disk-space.sh"
var TrackerDBMemoryCheck = "tracker-db-free-memory.sh"

//for click
var TrackerClickSystemKeeper = "tracker-click-system-keeper.sh"
var TrackerClickDiskSpace = "tracker-click-disk-space.sh"
var TrackerClickMemoryCheck = "tracker-click-free-memory.sh"
var TrackerClickErrorScanner = "tracker-click-error-scanner.sh"

//for postback
var TrackerPostbackSystemKeeper = "tracker-postback-system-keeper.sh"
var TrackerPostbackDiskSpace = "tracker-postback-disk-space.sh"
var TrackerPostbackMemoryCheck = "tracker-postback-free-memory.sh"
var TrackerPostbackErrorScanner = "tracker-postback-error-scanner.sh"

//deployment files
var TrackerAPP = "tracker_app"
var TrackerAPP2 = "tracker_app2"
var TrackerImpression = "tracker_impression"
var TrackerClick = "tracker_click"
var TrackerPostback = "tracker_postback"
var TrackerConfig = "tracker_config"
var TrackerDB = "tracker_db"
var TrackerJob = "tracker_job"
var TrackerAPPCluster = "tracker_app_cluster"
var GCPConfig = "gcp_config"
var TrackerSubscribersDeploy = "tracker_subscriber_deploy"
var TrackerSubscribersRestart = "tracker_subscriber_restart"
var TrackerSubscribersStop = "tracker_subscriber_stop"

//sms alerts
var messages = map[int]string{
	0: "Hi Adcamiens, Tracker Redis server is down . Please monitor its health",
	1: "Hi Adcamiens, Tracker Mongo Server is down. Please Take action as required",
	2: "Hi Adcamiens, Tracker Database Exception Check now",
	3: "Hi Adcamiens, Tracker Database is down",
	4: "Hi Adcamiens, Tracker App is down. Please check"}
