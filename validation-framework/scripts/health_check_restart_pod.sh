#!/bin/bash

function restartPod() {
  ((failruns=failruns+1))
  echo "[$mode] - calling restartPod at $failruns failures"
  if [ "$failthreshold" == "$failruns" ];
  then
    # restart="200"
    k8token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token);
    k8url="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/$KUBERNETES_NAMESPACE/pods/$HOSTNAME"
    restart=$(curl --insecure --write-out '%{http_code}' --silent --output /tmp/restart_pod.txt \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $k8token" \
    -X DELETE "$k8url");
    if [ "$restart" != "200" ] && [ "$restart" != "202" ];
    then
      # log format "[%\{TIMESTAMP_ISO8601:logdate}][%\{NUMBER}][%\{LOGLEVEL:severity}][%\{WORD}] [%\{DATA:envoy_source}\:%\{NUMBER:line_number}]\s+%{GREEDYDATA:raw}"
      echo "[`date -Is`][$failruns][error][restartpod] [health_check_restart_pod.sh:18] Unable to call K8 to restart pod $HOSTNAME in namespace $KUBERNETES_NAMESPACE and report liveness probe unhealthy" >> "/logs/envoy.application.log"
      rm $run_file
      exit 1
    else
      echo "[`date -Is`][$failruns][error][restartpod] [health_check_restart_pod.sh:22] Call K8 to restart pod $HOSTNAME in namespace $KUBERNETES_NAMESPACE for graceful pod rotation" >> "/logs/envoy.application.log"
      rm $run_file
      exit 0
    fi
  fi
  echo $failruns > $run_file
  exit 1
}
mode=$1
failthreshold=$2
customchecks=$3

run_file="/tmp/envoy_heath_checks_failure_$mode"
failruns=0
if [ -f $run_file ];
then 
  failruns=$(< $run_file)
fi

# http health check on envoy's health endpoint
# healthCheck="200"
healthCheck=$(curl --insecure --write-out '%{http_code}' --silent --output /dev/null -X GET "https://127.0.0.1:9443/healthz");

if [ "$healthCheck" != "200" ];
then
  echo "[$mode] - healthCheck: $healthCheck"
  restartPod
fi

if [ -z "$customchecks" ]
then
  echo "[$mode] - Skip custom endpoint testing";
else
  echo "[$mode] - Perform custom endpoint testing [https://127.0.0.1:9443/any/.info/mesh]";
  # envoyState="200"
  envoyState=$(curl --insecure --include --write-out '%{http_code}' --silent --output /tmp/out-$mode.txt -X GET "https://127.0.0.1:9443/any/.info/mesh");

  if [ "$envoyState" != "200" ];
  then
    echo "[$mode] - envoyState[https://127.0.0.1:9443/any/.info/mesh]: $envoyState"
    restartPod
  fi

  # enrich="true"
  enrich=$( grep '^x-epmp-wasm-enrich:' /tmp/out-$mode.txt | sed 's/^.*: //' );
  if [ -z "$enrich" ];
  then
    echo "[$mode] - got x-epmp-wasm-enrich"
    restartPod
  fi
fi

# envoyState=$(curl --write-out '%{http_code}' --silent --output /tmp/stats-$mode.json \
# -X GET "http://127.0.0.1:10000/stats?filter=cluster.local-myapp.upstream_cx_overflow&format=json");

# if [ "$envoyState" != "200" ];
# then
#   echo "[$mode] - envoyState[upstream_cx_overflow]: $envoyState"
#   restartPod
# fi

# overflowCheck=$(cat /tmp/stats-$mode.json | jq -r '.stats[0].value');
# if [ "$overflowCheck" != "0" ];
# then
#   echo "[$mode] - overflowCheck[upstream_cx_overflow]: $overflowCheck"
#   restartPod
# fi

# envoyState=$(curl --write-out '%{http_code}' --silent --output /tmp/stats.json \
# -X GET "http://127.0.0.1:10000/stats?filter=cluster.local-myapp.upstream_rq_pending_overflow&format=json");
# if [ "$envoyState" != "200" ];
# then
#   echo "[$mode] - envoyState[upstream_rq_pending_overflow]: $envoyState"
#   restartPod
# fi

# overflowCheck=$(cat /tmpstats-$mode.json | jq -r '.stats[0].value');
# if [ "$overflowCheck" != "0" ];
# then
#   echo "[$mode] - overflowCheck[upstream_rq_pending_overflow]: $overflowCheck"
#   restartPod
# fi

echo "[$mode] - Complete this run without any issue"
if [ -f $run_file ];
then 
  rm $run_file
fi
exit 0
