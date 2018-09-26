package gcp

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"strings"
	"time"

	"gopkg.in/mgo.v2/bson"
)

func GetServerLogs(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to list all server logs :")
	offset := 0
	events := []string{"server_init", "server_start", "server_stop", "pkg_init", "db_init"}
	eventFilters := map[string]interface{}{"$in": events}
	filters := map[string]interface{}{Event: eventFilters}

	if len(r.FormValue(Offset)) > 0 {
		offset, _ = strconv.Atoi(r.FormValue(Offset))
	}
	if len(r.FormValue(ServerType)) > 0 {
		filters = map[string]interface{}{ServerType: r.FormValue(ServerType)}
	}
	if len(r.FormValue(Event)) > 0 {
		filters = map[string]interface{}{Event: r.FormValue(Event)}
	}
	if len(r.FormValue(Host)) > 0 {
		filters[Host] = r.FormValue(Host)
	}
	results := GetLog(offset, ClusterLogColl, filters)
	bsonBytes, _ := json.Marshal(results)
	w.Write([]byte(bsonBytes))

}

func SetSMSAlerts(w http.ResponseWriter, r *http.Request) {
}

func GetAlerts(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to list all alerts from servers :")
	offset := 0
	var filters map[string]interface{}
	if len(r.FormValue(Offset)) > 0 {
		offset, _ = strconv.Atoi(r.FormValue(Offset))
	}
	results := GetLog(offset, AlertColl, filters)
	bsonBytes, _ := json.Marshal(results)
	w.Write([]byte(bsonBytes))

}

func GetServers(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to list all servers :")
	offset := 0
	var filters map[string]interface{}
	if len(r.FormValue(Offset)) > 0 {
		offset, _ = strconv.Atoi(r.FormValue(Offset))
	}
	for k, v := range r.Form {
		if strings.Compare(Offset, k) != 0 {
			filters[k] = v[0]
		}
	}
	results := GetLog(offset, GCPServerColl, filters)
	bsonBytes, _ := json.Marshal(results)
	w.Write([]byte(bsonBytes))

}

func GetDeploymentVersion(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to get version of deployment :")
	clusterLog := requestParser(r)
	clusterLog.Insert()
	filters := bson.M{DBServerType: clusterLog.ServerType}
	version := GetLatestDeploymentVersion(filters)
	w.Write([]byte(version))

}

func GetDeploymentVersionJson(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to get version of deployment :")
	clusterLog := requestParser(r)
	clusterLog.Insert()
	filters := bson.M{DBServerType: clusterLog.ServerType}
	version := GetLatestDeploymentVersionJson(filters)
	bsonBytes, _ := json.Marshal(version)
	w.Write([]byte(bsonBytes))

}

func GetServerLog(w http.ResponseWriter, r *http.Request) {
	log.Print("Got the request to get server log :")
	log := requestParser(r)
	paths := strings.Split(log.FilePath, "/")
	filename := paths[len(paths)-1]
	w.Header().Set("Content-Disposition", "attachment; filename="+filename)
	w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
	w.Header().Set("Access-Control-Allow-Headers", r.Header.Get("Access-Control-Request-Headers"))
	w.Header().Set("Content-type", "application/txt")
	w.Header().Set("Access-Control-Expose-Headers", "File-Name")
	w.Header().Set("File-Name", filename)

	filebytes, err := ioutil.ReadFile(log.FilePath)
	if err != nil {
		fmt.Println(err)

	}
	b := bytes.NewBuffer(filebytes)
	if _, err := b.WriteTo(w); err != nil { // <----- here!
		fmt.Fprintf(w, "%s", err)
	}
	w.Write(b.Bytes())

}

func requestParserListing(r *http.Request) *ClusterLog {
	clusterLog := new(ClusterLog)
	clusterLog.Host = r.FormValue(Host)
	clusterLog.ServerType = r.FormValue(ServerType)
	clusterLog.PublicIP = r.FormValue(PublicIP)
	clusterLog.BindIP = r.FormValue(BindIP)
	clusterLog.Event = r.FormValue(Event)
	clusterLog.Module = r.FormValue(Module)
	clusterLog.Environment = r.FormValue(Environment)
	clusterLog.UTCTime = time.Now().UTC()
	clusterLog.Insert()
	return clusterLog

}
