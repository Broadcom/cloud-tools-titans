#!/bin/bash
#set -e
# set -ex

option=$1

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
  gotpl tests/data/itests.sh.tpl -f values.yaml -f values-test.yaml -f values-env-override.yaml > tests/itests.sh
  chmod a+x tests/itests.sh
}

function runiTests {
  tests/itests.sh
  cat tests/logs/report.txt
}


preCheck
buildIntegrationTests

if [ "$option" != "--skip" ]
then
  runiTests
else
  echo ""
  echo "Skip running integration tests"
  echo "You can view generated integration script below"
  echo "tests/itests.sh"
fi





