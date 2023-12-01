#!/bin/bash
#set -e
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
subchart=""

function preCheck {
  if ! command -v docker-compose &> /dev/null
  then
      echo "docker-compose is required"
      echo "See README.md for detail"
      exit 1
  fi
  if ! command -v helm &> /dev/null
  then
      echo "helm tool is required"
      echo "See README.md for detail"
      exit 1
  fi
  if ! command -v gotpl &> /dev/null
  then
      echo "gotpl is required"
      echo "See README.md for detail"
      exit 1
  fi
  if ! command -v k8split &> /dev/null
  then
      echo "k8split is required"
      echo "See README.md for detail"
      exit 1
  fi

  if [ "$chartname" == "" ] && [ "$chartver" == "" ]; then
    echo "Please specify your umbrella helm chart name and version, e.g."
    echo "./validate_all.sh icds-all-in-one 1.203.48"
    echo "See README.md for detail"
    exit 1
  fi

  if [ -f "values-env-override.yaml" ]; then
    echo "Use enviornment overrides from values-env-override.yaml"
  else
    echo "Unable to find required values-env-override.yaml in the current directory"
    echo "Please see the README.md"
    exit 1
  fi

  if [ -f "$chartname-$chartver.tgz" ]; then
    rm -rf tmp
    mkdir -p tmp  
    echo "found $chartname-$chartver.tgz"
    mv "$chartname-$chartver.tgz" tmp
  else 
    if [ -f "tmp/$chartname-$chartver.tgz" ]; then
      echo "Use found tmp/$chartname-$chartver.tgz"
      mv "tmp/$chartname-$chartver.tgz" "$chartname-$chartver.tgz"
      rm -rf tmp
      mkdir -p tmp
      mv "$chartname-$chartver.tgz" "tmp/$chartname-$chartver.tgz"
    else
      echo "$chartname-$chartver.tgz is not found in current directory"
      echo "Will try to download as running from internal broadcom environment"    
    fi
  fi
}

function getTitansChart {
  validation_titan_version=$(grep '  version' Chart.yaml | sed 's/^.*: //')
  cd ..
  titan_chart_name=$( grep '^name' Chart.yaml | sed 's/^.*: //' )
  titan_chart_version=$( grep '^version' Chart.yaml | sed 's/^.*: //' )
  echo "Use cloud_tools_titans version: $titan_chart_version"
  if [ "$titan_chart_version" != "$validation_titan_version" ]; then
    echo "validation-framewor/Chart.yaml depends on version $validation_titan_version"
    echo "Please update validation-framewor/Chart.yaml to depend on the same version - $titan_chart_version"
    exit 1
  fi
  if [ -f "$titan_chart_name-$titan_chart_version.tgz" ]; then
    rm "$titan_chart_name-$titan_chart_version.tgz"
  fi
  ./scripts/package.sh
  rm -rf validation-framework/charts
  mkdir -p validation-framework/charts
  mv "$titan_chart_name-$titan_chart_version.tgz" validation-framework/charts
  cd validation-framework
}

function processAIOAdvance {
  if [ -f "tmp/$chartname-$chartver.tgz" ]; then
    echo "found tmp/$chartname-$chartver.tgz"
  else
    ./scripts/download.sh $chartname $chartver
  fi
  if ! [ -f "tmp/$chartname-$chartver.tgz" ]; then
    echo "tmp/$chartname-$chartver.tgz is not found"
    exit 1
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

function processChartsFromAIO {
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


function prepareDockerCompose {
  gotpl providers/docker-compose-titans.yaml.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > docker-compose.yaml
}

function prepareEnvoyConfigurations {
  helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml
  rm -rf envoy
  rm -rf tests
  mkdir -p envoy/config
  mkdir -p envoy/ratelimit/config
  mkdir -p tests/logs
  cd tmp/myapp/templates
  k8split configmap.yaml
  cd -
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-dmc.yaml --set select="envoy.yaml" > envoy/config/envoy.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-dmc.yaml --set select="envoy-sds.yaml" > envoy/config/envoy-sds.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-dmc.yaml --set select="ratelimit_config.yaml" > envoy/ratelimit/config/ratelimit_config.yaml
  mkdir -p envoy/config/cds
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-cds.yaml --set select="cds.yaml" > envoy/config/cds/cds.yaml
  mkdir -p envoy/config/lds
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-lds.yaml --set select="lds.yaml" > envoy/config/lds/lds.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="ratelimit_config.yaml" > envoy/ratelimit/config/ratelimit_config.yaml
}

function buildAutoGeneratedTests {
  mkdir -p tests/data
  cat gomplate/validation-test.sh.tpl > tests/data/validation-test.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/validation-test.sh.tpl
  cat gomplate/functions.tpl >> tests/data/validation-test.sh.tpl
  cat ../templates/envoy/_filter_wasm_enabled.yaml >> tests/data/validation-test.sh.tpl
  gotpl tests/data/validation-test.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml > tests/validation-test.sh
  chmod a+x tests/validation-test.sh
}

function buildLocalTests {
  mkdir -p tests/data
  cat gomplate/localtests.sh.tpl > tests/data/localtests.sh.tpl
  cat gomplate/test_core.sh.tpl >> tests/data/localtests.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/localtests.sh.tpl
  cat gomplate/functions.tpl >> tests/data/localtests.sh.tpl
  cat ../templates/envoy/_filter_wasm_enabled.yaml >> tests/data/localtests.sh.tpl
  gotpl tests/data/localtests.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > tests/localtests.sh
  chmod a+x tests/localtests.sh
}

function startupEnv {
  instance="validation-$RANDOM"
  docker-compose -p "$instance" up -d
}

function runTests {
  sleep 1
  docker exec --workdir /tests  "$instance-engine-1" bash validation-test.sh
  # mkdir -p tests/logs/"$subchart"
  cp tests/logs/report.txt tests/logs/report-auto.txt
  cat tests/logs/report-auto.txt
  if [ -s tests/localtests.sh ]; then
    docker exec --workdir /tests  "$instance-engine-1" bash localtests.sh
    cp tests/logs/report.txt tests/logs/report-local.txt
    cat tests/logs/report-local.txt
  fi
}

function stopEnv {
  docker-compose -p "$instance" down
}

preCheck
getTitansChart
processAIOAdvance

for file in "tmp/$chartname"/charts/*; do
  if [[ -d "$file" ]]; then
    subchart=$(basename $file)
    echo "####"
    echo "####"
    echo "Validate the $file/values.yaml of the $subchart helm chart"
    cp "$file/values.yaml" .
    prepareDockerCompose
    prepareEnvoyConfigurations
    buildAutoGeneratedTests
    buildLocalTests
    startupEnv
    runTests
    stopEnv
    rm values.yaml
    echo ""
    echo ""
  fi
done






