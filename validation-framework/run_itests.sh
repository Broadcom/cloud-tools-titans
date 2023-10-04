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
  if [ -f "values-itests.yaml" ] ; then
    echo "Found values-itests.yaml"
  else
    echo "Unable to find required values-itests.yaml in the current directory"
    echo "Please see the README.md"
    exit 1
  fi
}

function buildIntegrationTests {
  mkdir -p tests/data
  cp -r secrets tests
  cat gomplate/itests.sh.tpl > tests/data/itests.sh.tpl
  cat gomplate/test_core.sh.tpl >> tests/data/itests.sh.tpl
  cat gomplate/core_bash_functions.sh.tpl >> tests/data/itests.sh.tpl
  cat gomplate/functions.tpl >> tests/data/itests.sh.tpl
  gotpl tests/data/itests.sh.tpl -f values-itests.yaml > tests/itests.sh
  chmod a+x tests/itests.sh
}

function runiTests {
  docker run -v $(pwd)/tests:/tests -w /tests $image bash ./itests.sh
  cat tests/logs/report.txt
  mv tests/logs/report.txt tests/logs/report-it.txt
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





