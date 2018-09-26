package main

import (
	"log"
	"net/http"
	"time"

	gcp "github.com/adcamie/gcp-scripts/gcp"
	"github.com/rs/cors"
)

func init() {
	//kill existing process
	gcp.RunStopServerScript()
}

func main() {
	startServer()
}

func startServer() {
	time.Sleep(time.Second * 10)
	router := InitRoutes()
	server := &http.Server{
		Addr:    "0.0.0.0:8080",
		Handler: router,
	}
	log.Println("Listening...")
	server.ListenAndServe()
	log.Println("Not Listening........")

}

func InitRoutes() http.Handler {

	mux := http.NewServeMux()
	//basic operations in nodes
	mux.HandleFunc("/cluster/node/add", gcp.AddServer)
	mux.HandleFunc("/cluster/node/start", gcp.InitialiseClusterNode)
	mux.HandleFunc("/cluster/node/stop", gcp.ShutdownClusterNode)
	mux.HandleFunc("/cluster/node/health", gcp.CheckClusterNode)
	//db related
	mux.HandleFunc("/mongo/replica/init", gcp.InitialiseMongoReplica)
	//deployment related
	mux.HandleFunc("/deployment/version", gcp.GetDeploymentVersion)
	mux.HandleFunc("/deployment/version/json", gcp.GetDeploymentVersionJson)
	mux.HandleFunc("/deployment/init", gcp.InitiateDeployment)
	//monitoring servers in web/app
	mux.HandleFunc("/server/list", gcp.GetServers)
	mux.HandleFunc("/server/log", gcp.GetServerLog)
	mux.HandleFunc("/server/logs", gcp.GetServerLogs)
	//alerts
	mux.HandleFunc("/alert/new", gcp.AddAlert)
	mux.HandleFunc("/alert/list", gcp.GetAlerts)
	mux.HandleFunc("/alert/sms", gcp.SetSMSAlerts)
	//test url for redirection
	mux.HandleFunc("/test/redirect", gcp.TestRedirect)
	router := cors.Default().Handler(mux)
	return router
}
