package main

import (
    "fmt"
    "net/http"
    "github.com/cyberark/conjur-api-go/conjurapi"
)

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}

func handler(w http.ResponseWriter, r *http.Request) {

    // Fetch secrets from Conjur using authn-JWT
    variableIdentifier := "data/vault/POV/Database-MySQL-database.pov.example.com-admin/password"
    config, err := conjurapi.LoadConfig()
    if err != nil {
	fmt.Println("ERROR")
        panic(err)
    }
	
    conjur, err := conjurapi.NewClientFromEnvironment(config)
    if err != nil {
	fmt.Println("ERROR 2")
        panic(err)
    }
	
    secretValue, err := conjur.RetrieveSecret(variableIdentifier)
    if err != nil {
	fmt.Println("ERROR 3")
        panic(err)
    }

    fmt.Fprintf(w, "The Secret is: " + string(secretValue) )
}

