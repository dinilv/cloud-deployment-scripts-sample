package gcp

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"

	"gopkg.in/mgo.v2/bson"
)

func AddServer(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to add servers :")
	server := requestServerParser(r)
	//delete existing server with public IP
	filters := bson.M{DBPublicIP: server.PublicIP}
	DeleteLog(GCPServerColl, filters)
	//delete exiting server with host name as well
	filters = bson.M{Host: server.Host}
	DeleteLog(GCPServerColl, filters)
	server.Insert()

}
func AddAlert(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to add alert :")
	alert := requestAlertParser(r)
	//find respective module and send alert
	alert.Insert()

}

func InitialiseMongoReplica(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to intialise mongo replica :")
	clusterLog := requestParser(r)
	clusterLog.Status = Success
	err := RunMongoReplicaCommand(clusterLog.BindIP)
	if err != nil {
		clusterLog.Status = Fail
		alert := copyToAlert(clusterLog)
		alert.Details = "Adding mongo replication to master-cluster failed."
		alert.Insert()
	}
	clusterLog.Insert()
}

func InitialiseClusterNode(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to save node startup :")
	clusterLog := requestParser(r)
	clusterLog.Insert()

}
func ShutdownClusterNode(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to save node shutdown :")
	clusterLog := requestParser(r)
	clusterLog.Insert()

}

func CheckClusterNode(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to save node health status :")
	r.ParseMultipartForm(0)
	clusterLog := requestParser(r)
	//determine filepath to save
	file := clusterLog.FilePath + "_" + strconv.FormatInt(time.Now().UTC().Unix(), 10)
	reqFile, _, err := r.FormFile(File)
	if err != nil {
		fmt.Println(err)
	}
	//upload to Cloud storage
	UploadToCloudStorage(reqFile, trackerLogPath, clusterLog.ServerType+Separator+clusterLog.Module+Separator+clusterLog.PublicIP, file)
	//update log
	clusterLog.FilePath = LogPath + clusterLog.ServerType + Separator + clusterLog.Module + Separator + clusterLog.PublicIP + Separator + file
	clusterLog.Insert()
	w.Write([]byte(file))
}

func InitiateDeployment(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to initiate deployment :")
	resp := &Response{
		Status: 200,
	}
	deployLog := requestDeploymentReqParser(r)
	deployLog.Insert()
	//save to deployment file coll
	deployFile := copyToDeployFile(deployLog)
	deployFile.Insert()
	//run deployment
	switch deployLog.ServerType {

	case TrackerAPP:
		valid := DoTrackerAppDeployment(deployLog.Version, w)
		if !valid {
			return
		}
		//restart gcp servers for tracker-app
		filters := bson.M{DBServerType: TrackerAPPCluster}
		//query servers
		servers := GetAll(GCPServerColl, filters)
		errorLog := ""
		//restart with publicIP
		for _, server := range servers {
			err := RunRestartServer(server[DBPublicIP].(string))
			if err != nil {
				errorLog = errorLog + "-----" + err.Error()
			}
			time.Sleep(10 * time.Second)
		}
		if len(errorLog) > 0 {
			//report error
			resp = &Response{
				Status:  400,
				Message: errorLog,
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return
		}

	case TrackerAPP2:
		valid := DoTrackerAppDeployment2(deployLog.Version, w)
		if !valid {
			return
		}
		//restart gcp servers for tracker-app
		filters := bson.M{DBServerType: TrackerAPPCluster}
		//query servers
		servers := GetAll(GCPServerColl, filters)
		errorLog := ""
		//restart with publicIP
		for _, server := range servers {
			err := RunRestartServer(server[DBPublicIP].(string))
			if err != nil {
				errorLog = errorLog + "-----" + err.Error()
			}
			time.Sleep(10 * time.Second)
		}
		if len(errorLog) > 0 {
			//report error
			resp = &Response{
				Status:  400,
				Message: errorLog,
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return
		}

	case TrackerClick:
		valid := DoTrackerClickDeployment(deployLog.Version, w)
		if !valid {
			return
		}
		//restart gcp servers for tracker-app
		filters := bson.M{DBServerType: TrackerClick}
		//query servers
		servers := GetAll(GCPServerColl, filters)
		errorLog := ""
		//restart with publicIP
		for _, server := range servers {
			err := RunRestartServer(server[DBPublicIP].(string))
			if err != nil {
				errorLog = errorLog + "-----" + err.Error()
			}
			time.Sleep(10 * time.Second)
		}
		if len(errorLog) > 0 {
			//report error
			resp = &Response{
				Status:  400,
				Message: errorLog,
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return
		}

	case TrackerImpression:
		valid := DoTrackerImpressionDeployment(deployLog.Version, w)
		if !valid {
			return
		}
		//restart gcp servers for tracker-app
		filters := bson.M{DBServerType: TrackerImpression}
		//query servers
		servers := GetAll(GCPServerColl, filters)
		errorLog := ""
		//restart with publicIP
		for _, server := range servers {
			err := RunRestartServer(server[DBPublicIP].(string))
			if err != nil {
				errorLog = errorLog + "-----" + err.Error()
			}
			time.Sleep(10 * time.Second)
		}
		if len(errorLog) > 0 {
			//report error
			resp = &Response{
				Status:  400,
				Message: errorLog,
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))

		}

	default:
		err := RunDeploymentScript(deployLog.ServerType)
		if err != nil {
			resp = &Response{
				Status:  400,
				Message: err.Error(),
			}
		}
		bsonBytes, _ := json.Marshal(resp)
		w.Write([]byte(bsonBytes))
		return
	}
	return
}

func requestParser(r *http.Request) *ClusterLog {
	clusterLog := new(ClusterLog)
	clusterLog.Host = r.FormValue(Host)
	clusterLog.ServerType = r.FormValue(ServerType)
	clusterLog.PublicIP = r.FormValue(PublicIP)
	clusterLog.BindIP = r.FormValue(BindIP)
	clusterLog.Event = r.FormValue(Event)
	clusterLog.Module = r.FormValue(Module)
	clusterLog.File = r.FormValue(File)
	clusterLog.FilePath = r.FormValue(FileName)
	clusterLog.Environment = r.FormValue(Environment)
	clusterLog.UTCTime = time.Now().UTC()
	return clusterLog

}

func requestAlertParser(r *http.Request) *Alert {
	alert := new(Alert)
	alert.Host = r.FormValue(Host)
	alert.ServerType = r.FormValue(ServerType)
	alert.PublicIP = r.RemoteAddr
	alert.Details = r.FormValue(Details)
	alert.Event = r.FormValue(Event)
	alert.Module = r.FormValue(Module)
	alert.Environment = r.FormValue(Environment)
	alert.UTCTime = time.Now().UTC()
	return alert

}

func requestDeploymentReqParser(r *http.Request) *DeploymentReq {
	deployLog := new(DeploymentReq)
	deployLog.ServerType = r.FormValue(ServerType)
	deployLog.PublicIP = r.RemoteAddr
	deployLog.Version = r.FormValue(Version)
	deployLog.Module = r.FormValue(Module)
	deployLog.Environment = r.FormValue(Environment)
	deployLog.UTCTime = time.Now().UTC()
	return deployLog

}

func requestServerParser(r *http.Request) *GCPServer {
	server := new(GCPServer)
	server.Host = r.FormValue(Host)
	server.ServerType = r.FormValue(ServerType)
	server.PublicIP = r.FormValue(PublicIP)
	server.BindIP = r.FormValue(BindIP)
	server.UTCTime = time.Now().UTC()
	return server

}

func copyToAlert(clusterLog *ClusterLog) *Alert {
	alert := new(Alert)
	alert.Host = clusterLog.Host
	alert.ServerType = clusterLog.ServerType
	alert.PublicIP = clusterLog.PublicIP
	alert.BindIP = clusterLog.BindIP
	alert.Event = clusterLog.Event
	alert.Module = clusterLog.Module
	alert.Environment = clusterLog.Environment
	alert.UTCTime = time.Now().UTC()
	return alert

}

func copyToDeployFile(deployLog *DeploymentReq) *DeploymentFile {
	dfc := new(DeploymentFile)
	dfc.Version = deployLog.Version
	dfc.ServerType = deployLog.ServerType
	dfc.Module = deployLog.Module
	dfc.PublicIP = deployLog.PublicIP
	dfc.UTCTime = time.Now().UTC()
	return dfc

}
