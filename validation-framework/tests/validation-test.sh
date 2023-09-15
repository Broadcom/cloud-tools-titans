#!/bin/bash

trap 'trp' SIGUSR1
trap 'trp' SIGTERM
trp() {
  echo "[`date -Is`] receive signal to exit" >> "/tests/logs/prox-health-check.log"
  exit 0
}

while :         
do
  healthCheck=$(curl --insecure --write-out '%{http_code}' --silent --output /dev/null -X GET "https://proxy:9443/healthz");

  if [ "$healthCheck" != "200" ];
  then
    echo "[`date -Is`] healthCheck: $healthCheck" >> "/tests/logs/prox-health-check.log"
  else
    echo "[`date -Is`] healthCheck: $healthCheck" >> "/tests/logs/prox-health-check.log"
  fi

  sleep 5        
done