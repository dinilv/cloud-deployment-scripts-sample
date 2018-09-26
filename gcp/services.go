package gcp

import (
	"encoding/json"
	"net/http"
	"os"
	"strings"
)

const trackerDeploymentPath = "tracker-deployment"
const trackerDeploymentPath2 = "tracker-deployment2"
const trackerDBScriptPath = "tracker-db"
const trackerLogPath = "tracker-logs"

func DoTrackerPostbackDeployment(version string, w http.ResponseWriter) bool {
	resp := &Response{
		Status: 200,
	}
	RunDeploymentScript(TrackerPostback)

	//upload app files
	var appFiles = []string{TrackerAPIPostback, TrackerServicePostback, TrackerServicePostbackOfferMedia, TrackerPostbackSubscriber, TrackerDelayedSubscriber, TrackerFilteredSubscriber, TrackerPostbackPingSubscriber}

	for _, file := range appFiles {
		//replace version string
		fileVersion := strings.Replace(file, VERSION, version, -1)
		//read file
		fileBytes, err := os.Open(AdcamieGOPath + fileVersion)
		if err != nil {
			//report error
			resp = &Response{
				Status:  402,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
		UploadToCloudStorage(fileBytes, trackerDeploymentPath, "v"+version, fileVersion)
		if err != nil {
			//report error
			resp = &Response{
				Status:  400,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
	}

	return true
}

func DoTrackerClickDeployment(version string, w http.ResponseWriter) bool {

	resp := &Response{
		Status: 200,
	}
	RunDeploymentScript(TrackerClick)

	//upload click files
	var appFiles = []string{TrackerAPIClick, TrackerClickSubscriber, TrackerRotatedSubscriber}

	for _, file := range appFiles {
		//replace version string
		fileVersion := strings.Replace(file, VERSION, version, -1)
		//read file
		fileBytes, err := os.Open(AdcamieGOPath + fileVersion)
		if err != nil {
			//report error
			resp = &Response{
				Status:  402,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
		UploadToCloudStorage(fileBytes, trackerDeploymentPath, "v"+version, fileVersion)
		if err != nil {
			//report error
			resp = &Response{
				Status:  400,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
	}

	return true
}

func DoTrackerAppDeployment(version string, w http.ResponseWriter) bool {
	resp := &Response{
		Status: 200,
	}
	RunDeploymentScript(TrackerAPP)

	//upload components
	var compFiles = []string{FreeGEOIP, MICRO}

	for _, file := range compFiles {
		//read file
		fileBytes, err := os.Open(AdcamieGOPath + file)
		if err != nil {
			//report error
			resp = &Response{
				Status:  401,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
		UploadToCloudStorage(fileBytes, trackerDeploymentPath, "v"+version, file)
		if err != nil {
			//report error
			resp = &Response{
				Status:  400,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
	}

	//upload app files
	var appFiles = []string{TrackerAPIImpression, TrackerAPIClick, TrackerAPIPostback, TrackerServicePostback, TrackerServicePostbackOfferMedia, TrackerExceptionBroker,
		TrackerImpressionSubscriber, TrackerClickSubscriber, TrackerPostbackSubscriber, TrackerPostbackPingSubscriber, TrackerDelayedSubscriber, TrackerFilteredSubscriber, TrackerRotatedSubscriber}

	for _, file := range appFiles {
		//replace version string
		fileVersion := strings.Replace(file, VERSION, version, -1)
		//read file
		fileBytes, err := os.Open(AdcamieGOPath + fileVersion)
		if err != nil {
			//report error
			resp = &Response{
				Status:  402,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
		UploadToCloudStorage(fileBytes, trackerDeploymentPath, "v"+version, fileVersion)
		if err != nil {
			//report error
			resp = &Response{
				Status:  400,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
	}

	//upload scripts
	var scriptFiles = map[string]string{TrackerClickSystemKeeper: TrackerSystemKeeperPath,
		TrackerPostbackSystemKeeper: TrackerSystemKeeperPath, TrackerClickMemoryCheck: TrackerMonitorPath,
		TrackerPostbackMemoryCheck: TrackerMonitorPath, TrackerClickDiskSpace: TrackerMonitorPath, TrackerPostbackDiskSpace: TrackerMonitorPath, TrackerClickErrorScanner: TrackerMonitorPath, TrackerPostbackErrorScanner: TrackerMonitorPath}
	for file, path := range scriptFiles {
		//read file
		fileBytes, err := os.Open(path + file)
		if err != nil {
			//report error
			resp = &Response{
				Status:  403,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
		UploadToCloudStorage(fileBytes, trackerDeploymentPath, "v"+version, file)
		if err != nil {
			//report error
			resp = &Response{
				Status:  400,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
	}
	return true
}

func DoTrackerImpressionDeployment(version string, w http.ResponseWriter) bool {
	return true
}

func DoTrackerAppDeployment2(version string, w http.ResponseWriter) bool {
	resp := &Response{
		Status: 200,
	}
	RunDeploymentScript(TrackerAPP)

	//upload components
	var compFiles = []string{FreeGEOIP, MICRO}

	for _, file := range compFiles {
		//read file
		fileBytes, err := os.Open(AdcamieGOPath + file)
		if err != nil {
			//report error
			resp = &Response{
				Status:  401,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
		UploadToCloudStorage(fileBytes, trackerDeploymentPath2, "v"+version, file)
		if err != nil {
			//report error
			resp = &Response{
				Status:  400,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
	}

	//upload app files
	var appFiles = []string{TrackerAPIImpression, TrackerAPIClick, TrackerAPIPostback, TrackerServicePostback, TrackerServicePostbackOfferMedia, TrackerExceptionBroker,
		TrackerImpressionSubscriber, TrackerClickSubscriber, TrackerPostbackSubscriber, TrackerPostbackPingSubscriber, TrackerDelayedSubscriber, TrackerFilteredSubscriber, TrackerRotatedSubscriber}

	for _, file := range appFiles {
		//replace version string
		fileVersion := strings.Replace(file, VERSION, version, -1)
		//read file
		fileBytes, err := os.Open(AdcamieGOPath + fileVersion)
		if err != nil {
			//report error
			resp = &Response{
				Status:  402,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
		UploadToCloudStorage(fileBytes, trackerDeploymentPath2, "v"+version, fileVersion)
		if err != nil {
			//report error
			resp = &Response{
				Status:  400,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
	}

	//upload scripts
	var scriptFiles = map[string]string{TrackerClickSystemKeeper: TrackerSystemKeeperPath,
		TrackerPostbackSystemKeeper: TrackerSystemKeeperPath, TrackerClickMemoryCheck: TrackerMonitorPath,
		TrackerPostbackMemoryCheck: TrackerMonitorPath, TrackerClickDiskSpace: TrackerMonitorPath, TrackerPostbackDiskSpace: TrackerMonitorPath, TrackerClickErrorScanner: TrackerMonitorPath, TrackerPostbackErrorScanner: TrackerMonitorPath}
	for file, path := range scriptFiles {
		//read file
		fileBytes, err := os.Open(path + file)
		if err != nil {
			//report error
			resp = &Response{
				Status:  403,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
		UploadToCloudStorage(fileBytes, trackerDeploymentPath, "v"+version, file)
		if err != nil {
			//report error
			resp = &Response{
				Status:  400,
				Message: err.Error(),
			}
			bsonBytes, _ := json.Marshal(resp)
			w.Write([]byte(bsonBytes))
			return false
		}
	}
	return true
}
