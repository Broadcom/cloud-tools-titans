#!/bin/bash

if [ -f "$HOME/.secrets/jfrog.key" ]; then
    echo "Found jfrog.key - continue"
else 
    echo "No jfrog.key, please create a jfrog.key file under your home directory .secrets hidden folder - Exiting"
    exit
fi

if ! command -v gotpl &> /dev/null
then
    echo "gotpl is not installed and please install gotpl, see gomplate/README.md for the detail"
    exit
fi


apikey=$(cat ~/.secrets/jfrog.key)

chartname=""
chartver=""
respository=""


if [ "$chartname" == "" ] && [ "$chartver" == "" ]; then
  chartStrs=$(gotpl gomplate/dependencies.tpl -f ./Chart.yaml)
  lines=$(echo $chartStrs | tr " " "\n")
  found=""
  mkdir -p charts
  for line in $lines
  do
      if [[ "$found" == "foundName" ]]; then
        chartname=$line
        found=""
      elif [[ "$found" == "foundVer" ]]; then
        chartver=$line
        found=""
      elif [[ "$found" == "foundRepository" ]]; then
        respository=$line
        found=""
      elif [[ "$line" == "name:" ]]; then
        found="foundName"
      elif [[ "$line" == "version:" ]]; then
        found="foundVer"
      elif [[ "$line" == "repository:" ]]; then
        found="foundRepository"
      fi
     if [ "$chartname" != "" ] && [ "$chartver" != "" ] && [ "$respository" != "" ]; then
        if [[ "$respository" == *"sedsep-icdm-helm-release-candidate-virtual"* ]]; then
          respository="$respository/sedsep-icdmcore"
        fi
        if [ -f "./charts/$chartname-$chartver.tgz" ]; then
          echo "found ./charts/$chartname-$chartver.tgz"
        else
          echo "download $respository/$chartname/$chartname-$chartver.tgz"
          response=$(curl -H "X-JFrog-Art-Api:$apikey" --output charts/$chartname-$chartver.tgz --write-out '%{http_code}' $respository/$chartname/$chartname-$chartver.tgz)
          if [ "$response" != "200" ]; then
              echo "Got" $response
          else 
              echo "charts/$chartname-$chartver.tgz is downloaded successfully"
          fi
        fi
        chartname=""
        chartver=""
        respository=""      
      fi
  done
fi


