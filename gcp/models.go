package gcp

import (
	"time"

	mgo "gopkg.in/mgo.v2"
)

var clusterLogCollection *mgo.Collection
var deploymentFileCollection *mgo.Collection
var deploymentReqCollection *mgo.Collection
var gcpServerCollection *mgo.Collection
var alertCollection *mgo.Collection
var SMSLogCollection *mgo.Collection

func init() {
	clusterLogCollection = MongoSession.DB(DB).C(ClusterLogColl)
	gcpServerCollection = MongoSession.DB(DB).C(GCPServerColl)
	deploymentFileCollection = MongoSession.DB(DB).C(DeploymentFileColl)
	deploymentReqCollection = MongoSession.DB(DB).C(DeploymentReqColl)
	alertCollection = MongoSession.DB(DB).C(AlertColl)
	SMSLogCollection = MongoSession.DB(DB).C(SMSColl)
}

type ClusterLog struct {
	BindIP      string    `json:"bindIP,omitempty" bson:"bindIP,omitempty"`
	PublicIP    string    `json:"publicIP,omitempty" bson:"publicIP,omitempty"`
	Host        string    `json:"host,omitempty" bson:"host,omitempty"`
	ServerType  string    `json:"serverType,omitempty" bson:"serverType,omitempty"`
	Event       string    `json:"event,omitempty" bson:"event,omitempty"`
	Module      string    `json:"module,omitempty" bson:"module,omitempty"`
	Environment string    `json:"env,omitempty" bson:"env,omitempty"`
	Status      string    `json:"status,omitempty" bson:"status,omitempty"`
	UTCTime     time.Time `json:"utctime,omitempty" bson:"utctime,omitempty"`
	FilePath    string    `json:"filePath,omitempty" bson:"filePath,omitempty"`
	File        string    `json:"file,omitempty" bson:"file,omitempty"`
}

type DeploymentReq struct {
	BindIP      string    `json:"bindIP,omitempty" bson:"bindIP,omitempty"`
	PublicIP    string    `json:"publicIP,omitempty" bson:"publicIP,omitempty"`
	Environment string    `json:"env,omitempty" bson:"env,omitempty"`
	ServerType  string    `json:"serverType,omitempty" bson:"serverType,omitempty"`
	Module      string    `json:"module,omitempty" bson:"module,omitempty"`
	Version     string    `json:"version,omitempty" bson:"version,omitempty"`
	UTCTime     time.Time `json:"utctime,omitempty" bson:"utctime,omitempty"`
}

type DeploymentFile struct {
	BindIP     string    `json:"bindIP,omitempty" bson:"bindIP,omitempty"`
	PublicIP   string    `json:"publicIP,omitempty" bson:"publicIP,omitempty"`
	Module     string    `json:"module,omitempty" bson:"module,omitempty"`
	ServerType string    `json:"serverType,omitempty" bson:"serverType,omitempty"`
	Version    string    `json:"version,omitempty" bson:"version,omitempty"`
	UTCTime    time.Time `json:"utctime,omitempty" bson:"utctime,omitempty"`
}

type GCPServer struct {
	BindIP     string    `json:"bindIP,omitempty" bson:"bindIP,omitempty"`
	PublicIP   string    `json:"publicIP,omitempty" bson:"publicIP,omitempty"`
	Host       string    `json:"host,omitempty" bson:"host,omitempty"`
	ServerType string    `json:"serverType,omitempty" bson:"serverType,omitempty"`
	UTCTime    time.Time `json:"utctime,omitempty" bson:"utctime,omitempty"`
}

type Alert struct {
	BindIP      string    `json:"bindIP,omitempty" bson:"bindIP,omitempty"`
	PublicIP    string    `json:"publicIP,omitempty" bson:"publicIP,omitempty"`
	Host        string    `json:"host,omitempty" bson:"host,omitempty"`
	Environment string    `json:"env,omitempty" bson:"env,omitempty"`
	ServerType  string    `json:"serverType,omitempty" bson:"serverType,omitempty"`
	Module      string    `json:"module,omitempty" bson:"module,omitempty"`
	Event       string    `json:"event,omitempty" bson:"event,omitempty"`
	Details     string    `json:"details,omitempty" bson:"details,omitempty"`
	Comment     string    `json:"comment,omitempty" bson:"comment,omitempty"`
	UTCTime     time.Time `json:"utctime,omitempty" bson:"utctime,omitempty"`
}

type SMS struct {
	Mobile    map[string]bool
	MessageID int
	Message   string
	Error     string
	Request   string
	Response  string
}
type Response struct {
	Status  int
	Message string
}

func (w *SMS) Insert() error {
	err := SMSLogCollection.Insert(w)
	return err
}

func (w *ClusterLog) Insert() error {
	err := clusterLogCollection.Insert(w)
	return err
}
func (w *Alert) Insert() error {
	err := alertCollection.Insert(w)
	return err
}

func (w *DeploymentFile) Insert() error {
	err := deploymentFileCollection.Insert(w)
	return err
}
func (w *DeploymentReq) Insert() error {
	err := deploymentReqCollection.Insert(w)
	return err
}
func (w *GCPServer) Insert() error {
	err := gcpServerCollection.Insert(w)
	return err
}
