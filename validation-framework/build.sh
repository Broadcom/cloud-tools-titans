#!/bin/bash
set -e
# set -ex
currentDir=$PWD
chartname=""
if [ "$1" ];then
  chartname="$1"
fi
chartver=""
if [ "$2" ];then
  chartver="$2"
fi

function preCheck {
  if [ "$chartname" == "" ] && [ "$chartver" == "" ]; then
    echo "Please specify your umbrella helm chart name and version, e.g."
    echo "./build.sh icds-all-in-one 1.203.48"
    exit 1
  fi
  rm -rf tmp
  mkdir -p tmp
  if [ -f "$chartname-$chartver.tgz" ]; then
    echo "found $chartname-$chartver.tgz"
    mv "$chartname-$chartver.tgz" tmp
  else
    echo "$chartname-$chartver.tgz is not found in current directory"
    echo "Will try to download as internal broadcom environment"
  fi
}

function processAIOAdvance {
  if [ -f "tmp/$chartname-$chartver.tgz" ]; then
    echo "found tmp/$chartname-$chartver.tgz"
  else
    ./scripts/download.sh $chartname $chartver
  fi
  cd tmp
  tar xf $chartname-$chartver.tgz
  gotpl ../gomplate/fix-umbrella-chart.tpl -f "$chartname/Chart.yaml" --set path="$chartname" > handlalice.sh
  chmod a+x handlalice.sh
  ./handlalice.sh
  for file in "$chartname"/charts/*; do
    if [[ -d "$file" ]]; then
      gotpl ../gomplate/extract_routes.tpl -f "$file/values.yaml" --set cluster="$(basename $file)" >> clusters.yaml
    fi
  done
  gotpl ../gomplate/build_cluster.tpl -f clusters.yaml > ../values-test-clusters.yaml
  cd ..
}

function processAIO {
  if [ -f "tmp/$chartname-$chartver.tgz" ]; then
    echo "found tmp/$chartname-$chartver.tgz"
  else
    ./scripts/download.sh $chartname $chartver
  fi
  cd tmp
  tar xf $chartname-$chartver.tgz
  for file in "$chartname"/charts/*; do
    if [[ -d "$file" ]]; then
      gotpl ../gomplate/extract_routes.tpl -f "$file/values.yaml" --set cluster="$(basename $file)" >> clusters.yaml
    fi
  done
  gotpl ../gomplate/build_cluster.tpl -f clusters.yaml > ../values-test-clusters.yaml
  cd ..
}

function prepareDockerCompose {
  gotpl providers/docker-compose-titans.yaml.tpl -f values.yaml -f values-test.yaml > docker-compose.yaml
}

function prepareEnvoyConfigurations {
  helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml -f values-test-clusters.yaml
  rm -rf envoy
  rm -rf tests/logs
  mkdir -p envoy/config
  mkdir -p envoy/ratelimit/config
  mkdir -p tests/logs
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="envoy.yaml" > envoy/config/envoy.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="cds.yaml" > envoy/config/cds.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="lds.yaml" > envoy/config/lds.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="envoy-sds.yaml" > envoy/config/envoy-sds.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="ratelimit_config.yaml" > envoy/ratelimit/config/ratelimit_config.yaml
}

preCheck
processAIOAdvance
prepareDockerCompose
prepareEnvoyConfigurations


