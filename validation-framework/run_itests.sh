#!/bin/bash
#set -e
# set -ex

image="cfmanteiga/alpine-bash-curl-jq"

for arg in "$@"; do
  if [[ $arg == "--image" || $arg == "-i" ]]
  then
    shift
    image=$1
    shift
  elif [[ $arg == "--skip" || $arg == "-s" ]]
  then
    skip="--skip"
    shift
  elif [[ $arg == "--help" || $arg == "-h" ]]
  then
    echo "run_itests.sh [-s|--skip] [-i|--image \"container image used to run integration tests\"]"
    exit 0
  fi
done

function preCheck {
  if [ -f "values-env-override.yaml" ] && [ -f "values.yaml" ]; then
    echo "Found service's values.yam"
    echo "Use enviornment overrides from values-env-override.yaml"
  else
    echo "Unable to find required vaules.yaml and/or values-env-override.yaml in the current directory"
    echo "Please see the README.md"
    exit 1
  fi
}

function buildIntegrationTests {
  mkdir -p tests/data
  cat gomplate/itests.sh.tpl > tests/data/itests.sh.tpl
  cat gomplate/test_core.sh.tpl >> tests/data/itests.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/itests.sh.tpl
  cat gomplate/functions.tpl >> tests/data/itests.sh.tpl
  cat ../templates/envoy/_filter_wasm_enabled.yaml >> tests/data/itests.sh.tpl
  gotpl tests/data/itests.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > tests/itests.sh
  chmod a+x tests/itests.sh
}

function runiTests {
  docker run -v $(pwd)/tests:/tests -w /tests $image  bash ./itests.sh
  cat tests/logs/report.txt
}


preCheck
buildIntegrationTests

if [ "$skip" != "--skip" ]
then
  runiTests
else
  echo ""
  echo "Skip running integration tests"
  echo "You can view generated integration script below"
  echo "tests/itests.sh"
fi





