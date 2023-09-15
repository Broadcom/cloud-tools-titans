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

function processAIO {
  rm -rf tmp
  ./scripts/download.sh $chartname $chartver
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

processAIO
prepareDockerCompose
prepareEnvoyConfigurations


