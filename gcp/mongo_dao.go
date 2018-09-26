package gcp

import (
	"log"

	"gopkg.in/mgo.v2/bson"
)

func GetLatestDeploymentVersion(filters bson.M) string {
	version := "1"
	var results = []DeploymentFile{}
	err := MongoSession.DB(DB).C(DeploymentFileColl).Find(filters).Sort("-" + UTCTime).Limit(1).All(&results)
	if len(results) > 0 {
		version = results[0].Version
	}
	log.Println(err)
	return version
}
func GetLatestDeploymentVersionJson(filters bson.M) DeploymentFile {
	version := DeploymentFile{
		Version: "1",
	}
	var results = []DeploymentFile{}
	err := MongoSession.DB(DB).C(DeploymentFileColl).Find(filters).Sort("-" + UTCTime).Limit(1).All(&results)
	if len(results) > 0 {
		version = results[0]
	}
	log.Println(err)
	return version
}

func GetLog(offset int, coll string, filters bson.M) []bson.M {
	var results []bson.M
	err := MongoSession.DB(DB).C(coll).Find(filters).Skip((offset * 9)).Limit(10).Sort("-" + UTCTime).All(&results)
	if err != nil {
		log.Println(err)
	}
	return results
}

func GetAll(coll string, filters bson.M) []bson.M {
	var results []bson.M
	err := MongoSession.DB(DB).C(coll).Find(filters).All(&results)
	if err != nil {
		log.Println(err)
	}
	return results
}

func UpdateLog(coll string, filters bson.M, updates bson.M) {
	err, num := MongoSession.DB(DB).C(coll).UpdateAll(filters, bson.M{"$set": updates})
	log.Println(err, num)
}

func DeleteLog(coll string, filters bson.M) {
	err, num := MongoSession.DB(DB).C(coll).RemoveAll(filters)
	log.Println(err, num)
}
