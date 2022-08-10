#!/bin/bash



if [ -f "$HOME/.secrets/jfrog.key" ]; then
    echo "Found jfrog.key - continue"
else 
    echo "No jfrog.key, please create a jfrog.key file under your home directory .secrets hidden folder - Exiting"
    exit
fi

apikey=$(cat ~/.secrets/jfrog.key)
chartStrs=$(cat ./Chart.yaml)
chartname=""
chartver=""
lines=$(echo $chartStrs | tr " " "\n")
i=0
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

echo "chart name= $chartname" 
echo "chart ver= $chartver" 

mkdir -p tmp

chartresponse=$(helm package . -d tmp)

response=$(curl -H "X-JFrog-Art-Api:$apikey" --output tmp/$chartname-$chartver.tgz --write-out '%{http_code}' https://usw1.packages.broadcom.com/artifactory/sbo-sps-helm-release-local/$chartname/$chartname-$chartver.tgz)

if [ "$response" != "200" ]
then
    echo "Got" $response
else 
    echo "tmp/$chartname-$chartver.tgz is downloaded successfully"
fi
