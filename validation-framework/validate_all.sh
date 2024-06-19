#!/bin/bash
# set -e
# set -x

echo "Job start working directory: $PWD"

chartname=""
if [ "$1" ]; then chartname="$1"; fi

chartver=""
if [ "$2" ]; then chartver="$2"; fi




chartPackageFile="$chartname-$chartver.tgz"
composeCMD="docker-compose"
containerDelim="-"

function compose {
  echo "using $composeCMD"
  if [ "$composeCMD" = "podman-compose" ];
  then
    podman-compose $@
  elif [ "$composeCMD" = "docker-compose" ];
  then
    docker-compose $@
  else
    docker compose $@
  fi
}

function preCheck {
  # further required tools
  local readMeMsg="Please check README.md for details"

  # detect if docker or podman is installed locally
  if command -v podman-compose &> /dev/null
  then
    composeCMD="podman-compose"
    containerDelim="_"
  elif command -v docker-compose &> /dev/null
  then
    composeCMD="docker-compose"
    containerDelim="-"
  elif docker compose version &> /dev/null
  then
    composeCMD="docker compose"
    containerDelim="-"
  else
      echo "docker or podman compose is required"
      echo $readMeMsg
      exit 1
  fi

  if ! command -v helm &> /dev/null
  then
      echo "helm tool is required"
      echo $readMeMsg
      exit 1
  fi
  if ! command -v gotpl &> /dev/null
  then
      echo "gotpl is required"
      echo $readMeMsg
      exit 1
  fi
  if ! command -v k8split &> /dev/null
  then
      echo "k8split is required"
      echo $readMeMsg
      exit 1
  fi
  if ! command -v pajv &> /dev/null
  then
      echo "pajv is required, check github.com/json-schema-everywhere/pajv"
      echo $readMeMsg
      exit 1
  fi

  if [ -z "$chartname" ] || [ -z "$chartver" ]
  then
    echo "Please specify your umbrella helm chart name and version. For example:"
    echo "./validate_all.sh icds-all-in-one 1.203.48"
    echo $readMeMsg
    exit 1
  fi
  echo "Validate on $chartPackageFile"

  echo "Check all required files under directory: $PWD"
  if [ ! -f "values-env-override.yaml" ]
  then
    echo "Failed to locate required values-env-override.yaml under directory $PWD"
    echo $readMeMsg
    exit 1
  fi
  echo "Use enviornment overrides from $PWD/values-env-override.yaml"

  if [ -f "tmp/$chartPackageFile" ]
  then
    echo "Found $PWD/tmp/$chartPackageFile"
    mv "./tmp/$chartPackageFile" ./"$chartPackageFile"

    echo "Moved $PWD/tmp/$chartPackageFile to $PWD/$chartPackageFile" for later use
  fi

  if [ -f "$chartPackageFile" ]
  then
    echo "Found $PWD/$chartPackageFile"

    rm -rf tmp
    mkdir -p tmp
    
    mv "$chartPackageFile" ./tmp
    echo "Moved $PWD/$chartPackageFile to $PWD/tmp/$chartPackageFile"
  else
    echo "$chartPackageFile was not found under current directory: $PWD"
    echo "Will try to download as running from internal broadcom environment"
  fi
}

function getTitansChart {
  local validation_titan_version=$(grep '  version' Chart.yaml | sed 's/^.*: //')
  echo "validation_titan_version: $validation_titan_version"

  cd ..
  echo "Changed working directory to: $PWD"
  local titan_chart_name=$( grep '^name' Chart.yaml | sed 's/^.*: //' )
  local titan_chart_version=$( grep '^version' Chart.yaml | sed 's/^.*: //' )
  echo "titan_chart_version: $titan_chart_version"

  if [ "$titan_chart_version" != "$validation_titan_version" ]
  then
    echo "validation-framework/Chart.yaml depends on version $validation_titan_version"
    echo "Please update validation-framework/Chart.yaml to depend on the same version - $titan_chart_version"
    exit 1
  fi

  local titanChartPackageFile="$titan_chart_name-$titan_chart_version.tgz"
  if [ -f "$titanChartPackageFile" ]
  then
    rm "$titanChartPackageFile"
  fi
  ./scripts/package.sh
  rm -rf validation-framework/charts
  mkdir -p validation-framework/charts
  mv "$titanChartPackageFile" validation-framework/charts

  cd validation-framework
  echo "Changed working directory to: $PWD"
}

function cleanUpTestResult {
  rm -rf tests
  mkdir -p tests/logs
}

function processAIOAdvance {
  if [ -f "tmp/$chartPackageFile" ]
  then
    echo "found tmp/$chartPackageFile"
  else
    ./scripts/download.sh $chartname $chartver
    if [[ $? -ne 0 ]]
    then
      echo "Failed at process umbrella chart - download $chartPackageFile step"
      exit 1
    fi
  fi

  cd tmp
  echo "Changed working directory to: $PWD"

  tar xf $chartPackageFile
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
      if [ "$folder" != "sbo-sps-helm-baseline" ] && [ "$folder" != "titan-mesh-helm-lib-chart" ] && [ "$folder" != "envoy-ingress" ];
      then
        validateSchema "$PWD/.." "$PWD/$file/values.yaml" "$PWD/../tests/logs/schema_validation.log"
      fi

      if [ "$folder" != "envoy-ingress" ];
      then
        gotpl ../gomplate/extract_routes.tpl -f "$file/values.yaml" --set cluster="$folder" >> clusters.yaml
      fi
    fi
  done

  gotpl ../gomplate/build_cluster.tpl -f clusters.yaml > ../values-test-clusters.yaml
  if [[ $? -ne 0 ]]
  then
    echo "Failed at process umbrella chart - call build_cluster.tpl step"
    exit 1
  fi

  cd ..
  echo "Changed working directory to: $PWD"
}

function prepareDockerCompose {
  local rateLimitTest=${1:-0}

  if [[ $rateLimitTest -eq 0 ]]
  then 
    gotpl providers/docker-compose-titans.yaml.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-ratelimiting-disabled.yaml > docker-compose.yaml
  else
    gotpl providers/docker-compose-titans.yaml.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > docker-compose.yaml
  fi

  if [[ $? -ne 0 ]]
  then
    echo "Failed at prepareDockerCompose step"
    exit 1
  fi
}

function prepareEnvoyConfigurations {
  local rateLimitTest=${1:-0}

  if [[ $rateLimitTest -eq 0 ]]
  then
    helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml -f values-ratelimiting-disabled.yaml
  else
    helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml
  fi

  if [[ $? -ne 0 ]]
  then
    echo "Failed at prepareEnvoyConfigurations step"
    exit 1
  fi

  rm -rf envoy
  mkdir -p envoy/config/cds
  mkdir -p envoy/config/lds
  mkdir -p envoy/ratelimit/config

  cd tmp/myapp/templates
  echo "Changed working directory to: $PWD"
  k8split configmap.yaml

  cd -
  echo "Changed working directory to: $PWD"

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
  if [ -f "tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-cds.yaml" ]
  then
    gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-cds.yaml --set select="cds.yaml" > envoy/config/cds/cds.yaml
    if [[ $? -ne 0 ]]
    then
      echo "Failed at prepareEnvoyConfigurations - build cds.yaml step"
      exit 1
    fi
  else
    gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-dmc.yaml --set select="cds.yaml" > envoy/config/cds/cds.yaml
    if [[ $? -ne 0 ]]
    then
      echo "Failed at prepareEnvoyConfigurations - build cds.yaml from dmc-yaml step"
      exit 1
    fi
  fi
  mkdir -p envoy/config/lds
  if [ -f "tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-lds.yaml" ]
  then
    gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-lds.yaml --set select="lds.yaml" > envoy/config/lds/lds.yaml
    if [[ $? -ne 0 ]]
    then
      echo "Failed at prepareEnvoyConfigurations - build lds.yaml step"
      exit 1
    fi
  else
    gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap-validation-myapp-titan-configs-envoy-dmc.yaml --set select="lds.yaml" > envoy/config/lds/lds.yaml
    if [[ $? -ne 0 ]]
    then
      echo "Failed at prepareEnvoyConfigurations - build lds.yaml from dmc.yaml step"
      exit 1
    fi
  fi
}

function buildAutoGeneratedTests {
  local rateLimitTest=${1:-0}

  rm -rf tests/data
  mkdir -p tests/data

  cat gomplate/validation-test.sh.tpl > tests/data/validation-test.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/validation-test.sh.tpl
  cat gomplate/functions.tpl >> tests/data/validation-test.sh.tpl
  cat gomplate/functions_ratelimiting.tpl >> tests/data/validation-test.sh.tpl
  cat ../templates/envoy/_filter_wasm_enabled.yaml >> tests/data/validation-test.sh.tpl

  if [[ $rateLimitTest -eq 0 ]]
  then
    gotpl tests/data/validation-test.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml -f values-ratelimiting-disabled.yaml > tests/validation-test.sh
  else
    gotpl tests/data/validation-test.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml > tests/validation-test.sh
  fi

  if [[ $? -ne 0 ]]
  then
    echo "Failed at buildAutoGeneratedTests step"
    exit 1
  fi

  chmod a+x tests/validation-test.sh
}

function buildLocalTests {
  rm -rf tests/data
  mkdir -p tests/data

  cat gomplate/local_tests.sh.tpl > tests/data/local-tests.sh.tpl
  cat gomplate/test_core.sh.tpl >> tests/data/local-tests.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/local-tests.sh.tpl
  cat gomplate/functions.tpl >> tests/data/local-tests.sh.tpl
  cat ../templates/envoy/_filter_wasm_enabled.yaml >> tests/data/local-tests.sh.tpl

  gotpl tests/data/local-tests.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > tests/local-tests.sh
  if [[ $? -ne 0 ]]
  then
    echo "Failed at buildLocalTests step"
    exit 1
  fi

  chmod a+x tests/local-tests.sh
}

function forceLimitRateLimit {
  gotpl gomplate/overwrite_ratelimiting.tpl -f envoy/ratelimit/config/ratelimit_config.yaml > new_ratelimit_config.yaml
  mv -f new_ratelimit_config.yaml envoy/ratelimit/config/ratelimit_config.yaml
}

function validateSchema {
  local validationRootDir="$1"
  local dataFile="$2"
  local logFile="$3"
  local schemaDir="$1/../schemas"
  local extractTitanSideCarsTpl="$1/gomplate/extract_titanSideCars.tpl"
  local titanSideCarsOnlyYaml="$validationRootDir/tests/values.titanSideCarsOnly.yaml"

  if [[ ! -f "$dataFile" ]]; then
    echo "Error: "$dataFile" does not exist."
    exit 1
  fi

  echo "Start to validate schema on file: $dataFile, log error to: $logFile"
  gotpl "$extractTitanSideCarsTpl" -f "$dataFile" > "$titanSideCarsOnlyYaml"
  pajv -s "$schemaDir"/titanSideCars.json -r "$schemaDir"/cert.json -r "$schemaDir"/customTpls.json -r "$schemaDir"/egress_route.json -r "$schemaDir"/egress.json -r "$schemaDir"/enrich_action_match_header.json -r "$schemaDir"/enrich_action.json -r "$schemaDir"/enrich_transform.json -r "$schemaDir"/enrichment.json -r "$schemaDir"/envoy_cluster_route.json -r "$schemaDir"/envoy_cluster.json -r "$schemaDir"/envoy_enrichfilter.json  -r "$schemaDir"/envoy.json -r "$schemaDir"/imageRegistry.json -r "$schemaDir"/ingress_route.json -r "$schemaDir"/ingress.json -r "$schemaDir"/integration.json -r "$schemaDir"/issuers.json -r "$schemaDir"/logs.json -r "$schemaDir"/opa.json -r "$schemaDir"/ratelimit_action_match.json -r "$schemaDir"/ratelimit_match_condition.json -r "$schemaDir"/ratelimit_titanSideCars_envoy_clusters.json -r "$schemaDir"/ratelimit_titanSideCars_envoy.json -r "$schemaDir"/ratelimit_titanSideCars_ingress.json -r "$schemaDir"/ratelimit_titanSideCars.json -r "$schemaDir"/route_audit.json -r "$schemaDir"/route_enrich.json -r "$schemaDir"/route_match_header.json -r "$schemaDir"/route_match.json -r "$schemaDir"/route_metrics.json -r "$schemaDir"/route_ratelimit.json -r "$schemaDir"/route_rbac_policy_rule.json -r "$schemaDir"/route_rbac_policy.json -r "$schemaDir"/route_rbac.json -r "$schemaDir"/route_route.json -r "$schemaDir"/validation.json -r "$schemaDir"/versionFunction.json -d "$titanSideCarsOnlyYaml" > "$logFile" 2>&1
  if [[ $? -ne 0 ]]
  then
    echo "Failed at validateSchema step, error:"
    cat "$logFile"
    exit 1
  fi
}

function startDockerComposeEnv {
  instance="validation-$RANDOM"
  compose -p "$instance" up -d
  if [[ $? -ne 0 ]]
  then
    echo "Failed at startDockerComposeEnv step"
    exit 1
  fi
}

function runTests {
  local rateLimitTest=${1:-0}

  local autoTestTraceLogFile="test-trace_auto-without-ratelimit_$2.log"
  local autoTestEnvoyAppLogFile="envoy.application_auto-without-ratelimit_$2.log"
  local autoTestEnvoyLogFile="envoy_auto-without-ratelimit_$2.log"
  local autoTestReportFile="report_auto-without-ratelimit_$2.txt"
  if [[ $rateLimitTest -eq 1 ]]
  then
    autoTestTraceLogFile="test-trace_auto-with-ratelimit_$2.log"
    autoTestEnvoyAppLogFile="envoy.application_auto-with-ratelimit_$2.log"
    autoTestEnvoyLogFile="envoy_auto-with-ratelimit_$2.log"
    autoTestReportFile="report_auto-with-ratelimit_$2.txt"
  fi

  local testFailed=0

  sleep 1
  echo "Start running validation-test.sh"
  docker exec --workdir /tests "${instance}${containerDelim}engine${containerDelim}1" bash validation-test.sh
  if [[ $? -ne 0 ]]
  then
    echo "Failed at runTests - validation-test.sh step"
    testFailed=1
  fi

  mv tests/logs/auto-test-trace.log tests/logs/$autoTestTraceLogFile
  mv tests/logs/envoy.application.log tests/logs/$autoTestEnvoyAppLogFile
  mv tests/logs/envoy.log tests/logs/$autoTestEnvoyLogFile
  mv tests/logs/report.txt tests/logs/$autoTestReportFile
  cat tests/logs/$autoTestReportFile
  if [[ $testFailed -eq 1 ]]
  then
    if [ "$buildMode" != "--debug" ]
    then
      stopDockerComposeEnv
    fi
    exit 1
  fi

  if [ -s tests/local-tests.sh ]
  then
    echo "Start running local-tests.sh"

    local localTestTraceLogFile="test-trace_local-without-ratelimit_$2.log"
    local localTestEnvoyAppLogFile="envoy.application_local-without-ratelimit_$2.log"
    local localTestEnvoyLogFile="envoy_local-without-ratelimit_$2.log"
    local localTestReportFile="report_local-without-ratelimit_$2.txt"
    if [[ $rateLimitTest -eq 1 ]]
    then
      localTestTraceLogFile="test-trace_local-with-ratelimit_$2.log"
      localTestEnvoyAppLogFile="envoy.application_local-with-ratelimit_$2.log"
      localTestEnvoyLogFile="envoy_local-with-ratelimit_$2.log"
      localTestReportFile="report_local-with-ratelimit_$2.txt"
    fi

    docker exec --workdir /tests "$instance${containerDelim}engine${containerDelim}1" bash local-tests.sh
    if [[ $? -ne 0 ]]
    then
      echo "Failed at runTests - local-tests.sh step"
      testFailed=1
    fi

    mv tests/logs/local-test-trace.log tests/logs/$localTestTraceLogFile
    mv tests/logs/envoy.application.log tests/logs/$localTestEnvoyAppLogFile
    mv tests/logs/envoy.log tests/logs/$localTestEnvoyLogFile
    mv tests/logs/report.txt tests/logs/$localTestReportFile
    cat tests/logs/$localTestReportFile
    if [[ $testFailed -eq 1 ]]
    then
      if [ "$buildMode" != "--debug" ]
      then
        stopDockerComposeEnv
      fi
      exit 1
    fi
  fi
}

function stopDockerComposeEnv {
  compose -p "$instance" down
}

cleanUpTestResult

preCheck
getTitansChart
processAIOAdvance

for file in "tmp/$chartname"/charts/*; do
  if [[ -d "$file" ]]; then
    foundTitan=$(grep "titanSideCars:" "$file/values.yaml")
    # echo "foundTitan=[$foundTitan]"
    if [ "$foundTitan" == "titanSideCars:" ];
    then
      subchart=$(basename $file)

      echo "####"
      echo "####"
      echo "Validate the $file/values.yaml of the $subchart helm chart"

      if [ ! -f "$file/values.yaml" ]
      then
        echo "Failed to locate the values.yaml file under directory: $file"
        exit 1
      fi
      cp "$file/values.yaml" .
      echo "Copied $file/values.yaml to $PWD/values.yaml"

      cleanUpTestResult

      echo "Start tests without ratelimiting..."
      prepareDockerCompose 0
      prepareEnvoyConfigurations 0
      buildAutoGeneratedTests 0
      #buildLocalTests

      if grep "check_test_call" tests/validation-test.sh > /dev/null
      then
        startDockerComposeEnv
        runTests 0 "$subchart"
        stopDockerComposeEnv
      else
        echo "No auto test was generated, skip..."
      fi
      echo "Testing without ratelimitiing completed..."
      echo "*********************************************************************"

      echo "Start tests with ratelimiting..."
      prepareDockerCompose 1
      prepareEnvoyConfigurations 1
      forceLimitRateLimit
      buildAutoGeneratedTests 1
      #buildLocalTests
      if grep "check_test_call 429" tests/validation-test.sh > /dev/null
      then
        sleep 5
        startDockerComposeEnv
        runTests 1 "$subchart"
        stopDockerComposeEnv
      else
          echo "No ratelimit test was generated, skip..."
      fi
      echo "Testing without ratelimitiing completed..."

      rm values.yaml
      
      echo ""
      echo ""
      sleep 5
    else
      echo "Skip $file - not titans enabled"
    fi
  fi
done

echo "!!! Successfully completed all validation - All tests passed !!!"
