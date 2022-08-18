#!/bin/bash

apikey=$(cat ~/.secrets/jfrog.key)
chartname=$( grep '^name:' Chart.yaml | sed 's/^.*: //' )
chartver=$( grep '^version:' Chart.yaml | sed 's/^.*: //' )

echo "chart name= $chartname"
echo "chart version= $chartver"

chartresponse=$(sh scripts/package.sh)
if [ -f "$chartname-$chartver.tgz" ];then
response=$(curl -X PUT -H "X-JFrog-Art-Api:$apikey" -T $chartname-$chartver.tgz --write-out '%{http_code}' https://usw1.packages.broadcom.com/artifactory/sbo-sps-helm-release-local/$chartname/$chartname-$chartver.tgz)
if [ "$response" != "200" ]
then
    echo "Got Unexpected response" $response
else
    echo "Upload $chartname-$chartver.tgz successfully"
fi
rm "$chartname-$chartver.tgz"
else
  echo "$chartresponse"
  echo "chart did not package successfully"
fi