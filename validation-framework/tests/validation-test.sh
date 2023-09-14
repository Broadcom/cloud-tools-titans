#!/bin/bash

healthCheck=$(curl --insecure --write-out '%{http_code}' --silent --output /dev/null \
-X GET "https://proxy:9443/healthz");

if [ "$healthCheck" != "200" ];
then
  echo "[`date -Is`] healthCheck: $healthCheck" >> "/tests/healthCheck.log"
  exit 1
else
  echo "[`date -Is`] healthCheck: $healthCheck" >> "/tests/healthCheck.log"
fi

exit 0