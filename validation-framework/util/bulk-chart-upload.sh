#!/bin/bash

## replace ARTIFACTORY_API_KEY with your api key

## iterates through all folders in current directory that have my-chart sub-folder
## generates charts and puts them in charts/ folder
## finally uploads these charts to artifactory
 
rm charts/*

FILES=$PWD/*
for f in $FILES
do
    if [[ -f "$f/my-chart/Chart.yaml" ]]
    then
        cd $f
        git pull
        cd ..
        echo "Helm package chart $f file..."
        helm package $f/my-chart  -d ./charts
    fi
done

FILES=$PWD/charts/*
for f in $FILES
do
  c=`basename $f`
  s=${f%%.*}
  s=${s::${#s}-2}
  s=`basename $s`
  echo "Uploading chart $c for service $s"
  curl -H "X-JFrog-Art-Api:<ARTIFACTORY_API_KEY>" -X PUT "https://usw1.packages.broadcom.com/artifactory/sbo-sps-helm-release-local/$s/" -T charts/$c
done