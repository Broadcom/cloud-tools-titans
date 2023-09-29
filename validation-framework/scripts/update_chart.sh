#!/bin/bash

srcpath=""
if [ "$1" ];then
  srcpath="$1"
fi


cd  "./charts"
echo "$PWD"
for file in "."/*; do
  echo "$file"
  if [[ -d "$file" ]]; then
    echo "Skip directory - $file"
  else
    app=${file%-*}
    echo $app
    if [[ -d "$app" ]]; then
      echo "Skip untar - $file"
    else
      tar xf $file
    fi
    if [ -f "$app/templates/base_envoy_configmap.yaml" ]; then
      echo "cp $srcpath/templates/base_envoy_configmap.yaml $app/templates/base_envoy_configmap.yaml"
      cp "$srcpath/templates/base_envoy_configmap.yaml" "$app/templates/base_envoy_configmap.yaml"
      echo "cp $srcpath/envoy/envoy.yaml $app/envoy/envoy.yaml"
      cp "$srcpath/envoy/envoy.yaml" "$app/envoy/envoy.yaml"
      echo "cp $srcpath/templates/_envoy.tpl $app/templates/_envoy.tpl"
      cp "$srcpath/templates/_envoy.tpl" "$app/templates/_envoy.tpl"
      cd "$app"
      helm package . -d ..
      cd ..
    fi
    rm -r $app
  fi

done
cd ..
echo "$PWD"


