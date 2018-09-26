package gcp

import (
	"fmt"

	"gopkg.in/mgo.v2"
)

var MongoSession *mgo.Session

func init() {

	var err error
	fmt.Printf("Creating Session for mongo\n")
	MongoSession, err = mgo.DialWithInfo(&mgo.DialInfo{
		Addrs:    []string{"10.140.0.3:27017"},
		Username: "adcamie",
		Password: "gs#adcamie2017@nov",
		Database: "admin",
	})

	if err != nil {
		panic(err)
	}
}
