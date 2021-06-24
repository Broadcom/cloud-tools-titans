#!/bin/bash

apikey=$(cat ~/.secrets/jfrog.key)
chartStrs=$(cat ./Chart.yaml)
echo $chartStrs
chartname=""
chartver=""
lines=$(echo $chartStrs | tr " " "\n")
i=0
found=""
for line in $lines
do
    if [[ "$found" == "foundName" ]]; then
      echo "found name"
      chartname=$line
      found=""
    elif [[ "$found" == "foundVer" ]]; then
      echo "found ver"
      chartver=$line
      break
    elif [[ "$line" == "name:" ]]; then
      echo "$line"
      found="foundName"
    elif [[ "$line" == "version:"* ]]; then
      echo "$line"
      found="foundVer"
    else 
      echo "$line"
    fi
done

echo "chart name= $chartname" 
echo "chart ver= $chartver" 

mkdir -p tmp

chartresponse=$(helm package . -d tmp)

response=$(curl -H "X-JFrog-Art-Api:$apikey" -T tmp/$chartname-$chartver.tgz --write-out '%{http_code}' https://artifactory-lvn.broadcom.net/artifactory/sbo-sps-helm-release-local/$chartname/$chartname-$chartver.tgz)

if [ "$response" != "200" ]
then
    echo "Got" $response
else 
    echo "Upload $chartname-$chartver.tgz successfully"
fi
