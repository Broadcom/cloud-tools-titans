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

opt3=$3

function preCheck {
  if [ "$chartname" == "" ] && [ "$chartver" == "" ]; then
    echo "Please specify your umbrella helm chart name and version, e.g."
    echo "./build.sh icds-all-in-one 1.203.48"
    echo "See README.md for detail"
    exit 1
  fi

  if [ -f "values-env-override.yaml" ] && [ -f "values.yaml" ]; then
    echo "Found service's values.yam"
    echo "Use enviornment overrides from values-env-override.yaml"
  else
    echo "Unable to find required vaules.yaml and/or values-env-override.yaml in the current directory"
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
  gotpl providers/docker-compose-titans.yaml.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > docker-compose.yaml
}

function prepareEnvoyConfigurations {
  helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml
  rm -rf envoy
  rm -rf tests
  mkdir -p envoy/config
  mkdir -p envoy/ratelimit/config
  mkdir -p tests/logs
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="envoy.yaml" > envoy/config/envoy.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="cds.yaml" > envoy/config/cds.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="lds.yaml" > envoy/config/lds.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="envoy-sds.yaml" > envoy/config/envoy-sds.yaml
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="ratelimit_config.yaml" > envoy/ratelimit/config/ratelimit_config.yaml
}

function buildAutoGeneratedTests {
  mkdir -p tests/data
  cat gomplate/validation-test.sh.tpl > tests/data/validation-test.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/validation-test.sh.tpl
  cat gomplate/functions.tpl >> tests/data/validation-test.sh.tpl
  gotpl tests/data/validation-test.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml > tests/validation-test.sh
  chmod a+x tests/validation-test.sh
}

function buildLocalTests {
  mkdir -p tests/data
  cat gomplate/localtests.sh.tpl > tests/data/localtests.sh.tpl
  cat gomplate/test_core.sh.tpl >> tests/data/localtests.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/localtests.sh.tpl
  gotpl tests/data/localtests.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > tests/localtests.sh
  chmod a+x tests/localtests.sh
}

function buildIntegrationTests {
  mkdir -p tests/data
  cat gomplate/itests.sh.tpl > tests/data/itests.sh.tpl
  cat gomplate/test_core.sh.tpl >> tests/data/itests.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/itests.sh.tpl
  gotpl tests/data/itests.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > tests/itests.sh
  chmod a+x tests/itests.sh
}

function startupEnv {
  instance="validation-$RANDOM"
  docker-compose -p "$instance" up -d
}

function runTests {
  sleep 5
  docker exec --workdir /tests  "$instance-engine-1" bash validation-test.sh
  cat tests/logs/report.txt
  echo ""
  docker exec --workdir /tests  "$instance-engine-1" bash localtests.sh
  echo ""
  cat tests/logs/report.txt
}

function runiTests {
  tests/itests.sh
  cat tests/logs/report.txt
}

function stopEnv {
  docker-compose -p "$instance" down
}

if [ "$opt3" == "--build-local-tests" ]
then
  buildLocalTests
elif [ "$opt3" == "--build-itests" ]
then
  buildIntegrationTests
elif [ "$opt3" == "--build-auto-tests" ]
then
  buildAutoGeneratedTests
else 
  preCheck
  getTitansChart
  processAIOAdvance
  prepareDockerCompose
  prepareEnvoyConfigurations
  buildAutoGeneratedTests
  buildLocalTests
  buildIntegrationTests
  startupEnv
  runTests
  if [ "$opt3" != "--debug" ]
  then
    stopEnv
  else
    echo ""
    echo "Run following command to stop running test environment "
    echo "docker-compose -p $instance down"
    echo ""
  fi
fi




