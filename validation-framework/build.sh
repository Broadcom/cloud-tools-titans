#!/bin/sh
#set -e
#  set -x
currentDir=$PWD
chartname=""
if [ "$1" ];then
  chartname="$1"
fi
chartver=""
if [ "$2" ];then
  chartver="$2"
fi
composeCMD="docker-compose"
containerDelim="-"
opt3=$3
function compose {
  echo "using $composeCMD"
  if [ "$composeCMD" = "podman-compose" ]; then
    podman-compose $@
  elif [ "$composeCMD" = "docker-compose" ]; then
    docker-compose $@
  else
    docker compose $@
  fi
}
function preCheck {
  if command -v podman-compose &> /dev/null ;
  then
    composeCMD="podman-compose"
    containerDelim="_"
  elif command -v docker-compose &> /dev/null ;
  then
    composeCMD="docker-compose"
    containerDelim="-"
  elif docker compose version &> /dev/null ;
  then
    composeCMD="docker compose"
    containerDelim="-"
  else
      echo "docker or podman compose is required"
      echo "See README.md for detail"
      exit 1
  fi
  echo "using $composeCMD"
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
    echo "./build.sh icds-all-in-one 1.203.48"
    echo "See README.md for detail"
    exit 1
  fi

  if [ -f "values-env-override.yaml" ] && [ -f "values.yaml" ]; then
    echo "Found service's values.yaml"
    echo "Use enviornment overrides from values-env-override.yaml"
  else
    echo "Unable to find required values.yaml and/or values-env-override.yaml in the current directory"
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
  pwd
  validation_titan_version=$(grep '  version' Chart.yaml | sed 's/^.*: //')
  cd ..
  pwd
  titan_chart_name=$( grep '^name' Chart.yaml | sed 's/^.*: //' )
  titan_chart_version=$( grep '^version' Chart.yaml | sed 's/^.*: //' )
  echo "Use cloud_tools_titans version: $titan_chart_version"
  if [ "$titan_chart_version" != "$validation_titan_version" ]; then
    echo "validation-framework/Chart.yaml depends on version $validation_titan_version"
    echo "Please update validation-framework/Chart.yaml to depend on the same version - $titan_chart_version"
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
    if [[ $? -ne 0 ]]
    then
      echo "Failed at process umbrella chart - download $chartname-$chartver.tgz step"
      exit 1
    fi
  fi
  cd tmp
  tar xf $chartname-$chartver.tgz
  gotpl ../gomplate/fix-umbrella-chart.tpl -f "$chartname/Chart.yaml" --set path="$chartname" > handlalice.sh
  if [[ $? -ne 0 ]]
  then
    echo "Failed at process umbrella chart - process alias step"
    exit 1
  fi
  chmod a+x handlalice.sh
  ./handlalice.sh
  for file in "$chartname"/charts/*; do
    if [[ -d "$file" ]]; then
      folder=$(basename $file)
      if [ "$folder" != "envoy-ingress" ];
      then
        gotpl ../gomplate/extract_routes.tpl -f "$file/values.yaml" --set cluster="$folder" >> clusters.yaml
      fi
    fi
  done
  gotpl ../gomplate/build_cluster.tpl -f clusters.yaml > ../values-test-clusters.yaml
  if [[ $? -ne 0 ]]
  then
    echo "Failed at process umbrella chart step"
    exit 1
  fi
  cd ..
}

function prepareDockerCompose {
  gotpl providers/docker-compose-titans.yaml.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > docker-compose.yaml
  if [[ $? -ne 0 ]]
  then
    echo "Failed at prepareDockerCompose step"
    exit 1
  fi
}

function prepareEnvoyConfigurations {
  helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml
  if [[ $? -ne 0 ]]
  then
    echo "Failed at prepareEnvoyConfigurations step"
    exit 1
  fi
  rm -rf envoy
  rm -rf tests
  mkdir -p envoy/config
  mkdir -p envoy/ratelimit/config
  mkdir -p tests/logs
  cd tmp/myapp/templates
  k8split configmap.yaml
  cd -
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-dmc.yaml --set select="envoy.yaml" > envoy/config/envoy.yaml
  if [[ $? -ne 0 ]]
  then
    echo "Failed at prepareEnvoyConfigurations - build envoy.yaml step"
    exit 1
  fi
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-dmc.yaml --set select="envoy-sds.yaml" > envoy/config/envoy-sds.yaml
  if [[ $? -ne 0 ]]
  then
    echo "Failed at prepareEnvoyConfigurations - build envoy-sds.yaml step"
    exit 1
  fi

  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-dmc.yaml --set select="ratelimit_config.yaml" > envoy/ratelimit/config/ratelimit_config.yaml
  if [[ $? -ne 0 ]]
  then
    echo "Failed at prepareEnvoyConfigurations - build ratelimit_config.yaml step"
    exit 1
  fi
  mkdir -p envoy/config/cds
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-cds.yaml --set select="cds.yaml" > envoy/config/cds/cds.yaml
  if [[ $? -ne 0 ]]
  then
    echo "Failed at prepareEnvoyConfigurations - build cds.yaml step"
    exit 1
  fi
  mkdir -p envoy/config/lds
  gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-lds.yaml --set select="lds.yaml" > envoy/config/lds/lds.yaml
  if [[ $? -ne 0 ]]
  then
    echo "Failed at prepareEnvoyConfigurations - build lds.yaml step"
    exit 1
  fi
}

function buildAutoGeneratedTests {
  mkdir -p tests/data
  cat gomplate/validation-test.sh.tpl > tests/data/validation-test.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/validation-test.sh.tpl
  cat gomplate/functions.tpl >> tests/data/validation-test.sh.tpl
  cat ../templates/envoy/_filter_wasm_enabled.yaml >> tests/data/validation-test.sh.tpl
  gotpl tests/data/validation-test.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml > tests/validation-test.sh
  if [[ $? -ne 0 ]]
  then
    echo "Failed at buildAutoGeneratedTests step"
    exit 1
  fi
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
  if [[ $? -ne 0 ]]
  then
    echo "Failed at buildLocalTests step"
    exit 1
  fi
  chmod a+x tests/localtests.sh
}

function startupEnv {
  instance="validation-$RANDOM"
  compose -p "$instance" up -d
  if [[ $? -ne 0 ]]
  then
    echo "Failed at startupDockerComposeEnv step"
    exit 1
  fi
}

function runTests {
  sleep 1
  echo "Running validation-test.sh"
  docker exec --workdir /tests  "${instance}${containerDelim}engine${containerDelim}1" bash validation-test.sh
  if [[ $? -ne 0 ]]
  then
    echo "Failed at runTests - autotest step"
    failed="true"
  fi
  cp tests/logs/report.txt tests/logs/report-auto.txt
  cat tests/logs/report-auto.txt
  if [ -s tests/localtests.sh ]; then
    echo "Running localtests.sh"
    docker exec --workdir /tests  "$instance${containerDelim}engine${containerDelim}1" bash localtests.sh
    if [[ $? -ne 0 ]]
    then
      echo "Failed at runTests - localtests step"
      failed="true"
    fi
    cp tests/logs/report.txt tests/logs/report-local.txt
    cat tests/logs/report-local.txt
  fi
}

function stopEnv {

  compose -p "$instance" down
}

preCheck
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
  getTitansChart
  processAIOAdvance
  prepareDockerCompose
  prepareEnvoyConfigurations
  buildAutoGeneratedTests
  # buildLocalTests
  startupEnv
  failed="false"
  runTests
  if [ "$opt3" != "--debug" ]
  then
    stopEnv
  else
    echo ""
    echo "Run following command to stop running test environment "
    echo "docker compose -p $instance down"
    echo ""
  fi
  if [ "$failed" == "true" ]
  then
    exit 1
  fi
fi




