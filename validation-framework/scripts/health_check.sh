#!/bin/bash

testservicebase=$1
namespace=$2

healthCheck=$(curl --insecure --write-out '%{http_code}' --silent --output /dev/null \
-X GET "https://127.0.0.1:9443/healthz");

if [ "$healthCheck" != "200" ];
then
  echo "healthCheck: $healthCheck"
  exit 1
fi

if [ -z "$testservicebase" ]
then
  echo "Skip custom endpoint testing";
else
  echo "Perform custom endpoint testing [https://127.0.0.1:9443/$testservicebase/.info/mesh]";
  envoyState=$(curl --insecure --include --write-out '%{http_code}' --silent --output /tmp/out.txt \
  -X GET "https://127.0.0.1:9443/$testservicebase/.info/mesh");

  if [ "$envoyState" != "200" ];
  then
    echo "envoyState[https://127.0.0.1:9443/$testservicebase/.info/mesh]: $envoyState"
    exit 1
  fi

  enrich=$( grep '^x-epmp-wasm-enrich:' /tmp/out.txt | sed 's/^.*: //' );
  if [ -z "$enrich" ];
  then
    echo "No x-epmp-wasm-enrich response header found"
    if [ -z "$namespace" ];
    then
      exit 1
    else
      k8token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token);
      k8url="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/$namespace/pods/$HOSTNAME"
      restart=$(curl --insecure --write-out '%{http_code}' --silent --output /tmp/restart_pod.txt \
      -H "Accept: application/json" \
      -H "Authorization: Bearer $k8token" \
      -X DELETE "$k8url");
      if [ "$restart" != "200" ] && [ "$restart" != "202" ];
      then
        echo "Unable to call K8 to restart Kubernetes pod($namespace,$HOSTNAME) and report liveness probe unhealthy"
        exit 1
      else
        echo "Restart Kubernetes pod($namespace,$HOSTNAME) for gracefully pod rotation"
        exit 0
      fi
    fi
  fi
fi

envoyState=$(curl --write-out '%{http_code}' --silent --output /tmp/stats.json \
-X GET "http://127.0.0.1:10000/stats?filter=cluster.local-myapp.upstream_cx_overflow&format=json");

if [ "$envoyState" != "200" ];
then
  echo "envoyState[upstream_cx_overflow]: $envoyState"
  exit 1
fi

overflowCheck=$(cat /tmp/stats.json | jq -r '.stats[0].value');
if [ "$overflowCheck" != "0" ];
then
  echo "overflowCheck[upstream_cx_overflow]: $overflowCheck"
  exit 1
fi

envoyState=$(curl --write-out '%{http_code}' --silent --output /tmp/stats.json \
-X GET "http://127.0.0.1:10000/stats?filter=cluster.local-myapp.upstream_rq_pending_overflow&format=json");
if [ "$envoyState" != "200" ];
then
  echo "envoyState[upstream_rq_pending_overflow]: $envoyState"
  exit 1
fi

overflowCheck=$(cat /tmp/stats.json | jq -r '.stats[0].value');
if [ "$overflowCheck" != "0" ];
then
  echo "overflowCheck[upstream_rq_pending_overflow]: $overflowCheck"
  exit 1
fi

exit 0