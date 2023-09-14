#!/bin/bash

for (( ; ; ))
do
    response=$(curl --insecure --write-out '%{http_code}' --silent --output /dev/null --resolve $1:443:$2 https://$1/r3_epmp_i/status)
    echo "Got" $response
    sleep 1
done
