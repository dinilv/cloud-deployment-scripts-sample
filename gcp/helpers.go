package gcp

import (
	"context"
	"fmt"
	"io/ioutil"
	"log"
	"mime/multipart"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"strconv"
	"time"

	"cloud.google.com/go/storage"
	"golang.org/x/oauth2/google"
	storage2 "google.golang.org/api/storage/v1"
)

const projectID = "57244375192"
const scope = storage.ScopeFullControl

var smsHttpClient http.Client

func init() {
	smsHttpClient = http.Client{}
}
func RunMongoReplicaCommand(bindIP string) error {

	log.Println("Starting Mongo Command to Add Replica:-", time.Now().UTC())
	mongoReplicaAdd := "({host: " + bindIP + ", priority: 0})"
	cmd := exec.Command("mongo", "--eval", "rs.add('"+mongoReplicaAdd+"')")
	//cmd := exec.Command("mongo", "--eval", "rs.add('"+bindIP+"')")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Start()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error starting Cmd", err)
	}

	err = cmd.Wait()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error waiting for Cmd", err.Error())
	}
	log.Println("Done adding mongo replica", time.Now().UTC())
	return err
}

func RunRenameLogFileCommand(fullPath string) (string, error) {

	log.Println("Change existing log to old one:-", time.Now().UTC())
	timestamp := strconv.FormatInt(time.Now().UTC().Unix(), 10)
	newfilepath := fullPath + "_" + timestamp
	cmd := exec.Command("mv", fullPath, newfilepath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Start()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error starting Cmd", err)
	}
	err = cmd.Wait()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error waiting for Cmd", err.Error())
	}
	log.Println("Done renaming old file", time.Now().UTC())
	return newfilepath, err
}

func RunDeploymentScript(serverType string) error {
	log.Println("Start deployment folder", time.Now().UTC())
	var script = ""
	switch serverType {
	case TrackerAPP:
		script = TrackerAppScript
	case TrackerClick:
		script = TrackerClickScript
	case TrackerPostback:
		script = TrackerPostbackScript
	case TrackerConfig:
		script = TrackerConfigScript
	case TrackerJob:
		script = TrackerJobScript
	case TrackerSubscribersDeploy:
		script = TrackerSubscribersDeploy
	case TrackerSubscribersStop:
		script = TrackerSubscribersStop
	case TrackerSubscribersRestart:
		script = TrackerSubscribersRestartScript
	case GCPConfig:
		script = GCPConfigScript
	}
	cmd, err := exec.Command("/bin/sh", script).Output()
	log.Println(string(cmd), err)
	return err
}

func RunStopServerScript() {
	log.Println("Start deployment folder", time.Now().UTC())
	cmd, err := exec.Command("/bin/sh", GCPServerStopScript).Output()
	log.Println(string(cmd), err)
}

func RunRestartServer(ip string) error {
	log.Println("Restarting server:-", ip)
	//ssh root@35.198.238.11 reboot
	cmd := exec.Command("ssh", "root@"+ip, "reboot")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Start()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error starting Cmd", err)
	}

	err = cmd.Wait()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error waiting for Cmd", err.Error())
	}
	log.Println("Done restarting server", time.Now().UTC())
	return err
}

func SendSMS(s *SMS) {

	smsGatewayURL, _ := url.Parse("http://cloud.smsindiahub.in/vendorsms/pushsms.aspx?user=kunalag&password=kunvib@129&")
	var params = url.Values{}
	params.Add("sid", "SCAMIE")
	params.Add("msg", messages[s.MessageID])
	params.Add("fl", "0")
	params.Add("gwid", "2")

	for mob, _ := range s.Mobile {
		params.Add("msisdn", mob)
		req, _ := http.NewRequest("GET", smsGatewayURL.String()+params.Encode(), nil)
		res, _ := smsHttpClient.Do(req)
		body, _ := ioutil.ReadAll(res.Body)
		s.Request = string(req.URL.String())
		s.Response = string(body)
		s.Insert()
		defer res.Body.Close()
	}

}

func UploadToCloud(bucketName string, fileName string, filePath string) error {

	// Creates a client.
	client, err := storage.NewClient(context.Background())
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
	}
	bucket := client.Bucket("https://www.googleapis.com/storage/v1/b/tracker-deployment").UserProject(projectID)

	wc := bucket.Object(fileName).NewWriter(context.Background())
	wc.ContentType = "application/file"
	b, err := ioutil.ReadFile(filePath + fileName)

	if _, err := wc.Write(b); err != nil {
		log.Println("createFile: unable to write data to bucket , file", bucket, fileName, err)
		return err
	}

	if err := wc.Close(); err != nil {
		log.Println("createFile: unable to write data to bucket , file", bucket, fileName, err)
		return err
	}
	return nil
}

func UploadToCloudStorage(file multipart.File, path string, version string, filename string) error {

	object := &storage2.Object{Name: version + "/" + filename, ContentType: "application/file"}
	log.Println("filename", filename)
	client, err := google.DefaultClient(context.Background(), scope)
	if err != nil {
		log.Println("Unable to get default client:", err)
		return err
	}

	service, err := storage2.New(client)
	if err != nil {
		log.Println("Unable to create storage service: ", err)
		return err
	}
	res, err := service.Objects.Insert(path, object).Media(file).PredefinedAcl("publicRead").Do()
	if err != nil {
		log.Println(err, res, path, filename)
		return err
	}
	return nil
}
