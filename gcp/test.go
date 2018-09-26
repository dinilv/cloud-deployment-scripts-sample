package gcp

import (
	"log"
	"net/http"
	"time"
)

func TestRedirect(w http.ResponseWriter, r *http.Request) {

	log.Println(r.URL.String(), "-:-", r.URL.EscapedPath(), "-:-", time.Now())
	return
}
