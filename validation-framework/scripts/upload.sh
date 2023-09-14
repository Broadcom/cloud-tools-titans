#!/bin/bash



if [ -f "$HOME/.secrets/jfrog.key" ]; then
    echo "Found jfrog.key - continue"
else 
    echo "No jfrog.key, please create a jfrog.key file under your home directory .secrets hidden folder - Exiting"
    exit
fi

apikey=$(cat ~/.secrets/jfrog.key)
chartname=$( grep '^name:' Chart.yaml | sed 's/^.*: //' )
chartver=$( grep '^version:' Chart.yaml | sed 's/^.*: //' )

echo "chart name= $chartname" 
echo "chart ver= $chartver" 

mkdir -p tmp

chartresponse=$(helm package . -d tmp)

response=$(curl -H "X-JFrog-Art-Api:$apikey" -T tmp/$chartname-$chartver.tgz --write-out '%{http_code}' https://usw1.packages.broadcom.com/artifactory/sbo-sps-helm-release-local/$chartname/$chartname-$chartver.tgz)

if [ "$response" != "200" ]
then
    echo "Got" $response
else 
    echo "Upload $chartname-$chartver.tgz successfully"
fi
