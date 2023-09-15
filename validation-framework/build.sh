#!/bin/bash
set -e
# set -ex

function prepareDockerCompose {
  gotpl providers/docker-compose-titans.yaml.tpl -f values.yaml -f values-test.yaml > docker-compose.yaml
}

function prepareEnvoyConfigurations {
  helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml
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

prepareDockerCompose
prepareEnvoyConfigurations


