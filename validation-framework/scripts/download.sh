#!/bin/bash

if [ -f "$HOME/.secrets/jfrog.key" ]; then
    echo "Found jfrog.key - continue"
else 
    echo "No jfrog.key, please create a jfrog.key file under your home directory .secrets hidden folder - Exiting"
    exit
fi

apikey=$(cat ~/.secrets/jfrog.key)

chartname=""
if [ "$1" ];then
  chartname="$1"
fi
chartver=""
if [ "$2" ];then
  chartver="$2"
fi

if [ "$chartname" == "" ] && [ "$chartver" == "" ]; then
  chartStrs=$(cat ./Chart.yaml)
  lines=$(echo $chartStrs | tr " " "\n")
  found=""
  for line in $lines
  do
      if [[ "$found" == "foundName" ]]; then
        chartname=$line
        found=""
      elif [[ "$found" == "foundVer" ]]; then
        chartver=$line
        break
      elif [[ "$line" == "name:" ]]; then
        found="foundName"
      elif [[ "$line" == "version:"* ]]; then
        found="foundVer"
      fi
  done
fi

echo "chart name= $chartname" 
echo "chart ver= $chartver" 

mkdir -p tmp

response=$(curl -H "X-JFrog-Art-Api:$apikey" --output tmp/$chartname-$chartver.tgz --write-out '%{http_code}' https://usw1.packages.broadcom.com/artifactory/sbo-sps-helm-release-local/$chartname/$chartname-$chartver.tgz)

if [ "$response" != "200" ]
then
    echo "Got" $response
else 
    echo "tmp/$chartname-$chartver.tgz is downloaded successfully"
fi
