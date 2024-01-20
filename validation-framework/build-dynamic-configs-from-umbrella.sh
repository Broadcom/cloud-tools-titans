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

releaseName="icds-dev-stage-release"
if [ "$3" ];then
  releaseName="$3"
fi


containerDelim="-"
function preCheck {
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
  mkdir -p "envoy/$chartname/charts"
  mkdir -p "envoy/$chartname/templates"
  for file in "$chartname"/templates/*; do
    if [[ -f "$file" ]]; then
      filename=$(basename $file)
      extension="${filename##*.}"
      if [ "$extension" == "tpl" ];
      then
        cp  "$file" "envoy/$chartname/templates"
      fi
    fi
  done

  cp "$chartname/Chart.yaml" "envoy/$chartname"
  for file in "$chartname"/charts/*; do
    if [[ -d "$file" ]]; then
      folder=$(basename $file)
      charttype=$( grep '^type:' $chartname/charts/$folder/Chart.yaml | sed 's/^.*: //' )
      if [ "$charttype" == "library" ];
      then
        cp -r "$chartname/charts/$folder" "envoy/$chartname/charts"
        cd "envoy/$chartname/charts/$folder"
        helm package . -d ..
        cd ..
        rm -rf "$folder"
        cd "$currentDir/tmp"
      else
        mkdir -p "envoy/$chartname/charts/$folder/templates"
        echo '{{ include "titan-mesh-helm-lib-chart.configmap" . }}' > "envoy/$chartname/charts/$folder/templates/configmap.yaml"
        cp "$chartname/charts/$folder/values.yaml" "envoy/$chartname/charts/$folder/values.yaml"
        cp "$chartname/charts/$folder/Chart.yaml" "envoy/$chartname/charts/$folder/Chart.yaml"
        cd "envoy/$chartname/charts/$folder"
        helm package . -d ..
        cd ..
        rm -rf "$folder"
        cd "$currentDir/tmp"
      fi
    fi
  done
  cd ..
}

function prepareEnvoyConfigurations {
  # helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml -f values-env-override.yaml -f values-test-clusters.yaml
  # if [[ $? -ne 0 ]]
  # then
  #   echo "Failed at prepareEnvoyConfigurations step"
  #   exit 1
  # fi
  cd tmp
  envoyconfigmaps="envoy/configmaps/$chartname"
  envoyconfigs="envoy/configs/$chartname"

  for file in "$envoyconfigmaps"/charts/*; do
    if [[ -d "$file" ]]; then
      folder=$(basename $file)
      mkdir -p "$envoyconfigs/$folder/envoy/config"
      mkdir -p "$envoyconfigs/$folder/envoy/ratelimit/config"
      cd "$envoyconfigmaps/charts/$folder/templates"
      k8split configmap.yaml
      cd -
      gotpl ../gomplate/extract_envoy.tpl -f "$envoyconfigmaps/charts/$folder/templates/configmap-$releaseName-$folder-titan-configs-envoy-dmc.yaml" --set select="envoy.yaml" > "$envoyconfigs/$folder/envoy/envoy.yaml"
      if [[ $? -ne 0 ]]
      then
        echo "Failed at prepareEnvoyConfigurations - build envoy.yaml step"
        exit 1
      fi
      gotpl ../gomplate/extract_envoy.tpl -f "$envoyconfigmaps/charts/$folder/templates/configmap-$releaseName-$folder-titan-configs-envoy-dmc.yaml" --set select="envoy-sds.yaml" > "$envoyconfigs/$folder/envoy/config/envoy-sds.yaml"
      if [[ $? -ne 0 ]]
      then
        echo "Failed at prepareEnvoyConfigurations - build envoy-sds.yaml step"
        exit 1
      fi
      gotpl ../gomplate/extract_envoy.tpl -f "$envoyconfigmaps/charts/$folder/templates/configmap-$releaseName-$folder-titan-configs-envoy-dmc.yaml" --set select="ratelimit_config.yaml" > "$envoyconfigs/$folder/envoy/ratelimit/config/ratelimit_config.yaml"
      if [[ $? -ne 0 ]]
      then
        echo "Failed at prepareEnvoyConfigurations - build ratelimit_config.yaml step"
        exit 1
      fi
      gotpl ../gomplate/extract_envoy.tpl -f "$envoyconfigmaps/charts/$folder/templates/configmap-$releaseName-$folder-titan-configs-envoy-cds.yaml" --set select="cds.yaml" > "$envoyconfigs/$folder/envoy/config/cds.yaml"
      if [[ $? -ne 0 ]]
      then
        echo "Failed at prepareEnvoyConfigurations - build cds.yaml step"
        exit 1
      fi
      gotpl ../gomplate/extract_envoy.tpl -f "$envoyconfigmaps/charts/$folder/templates/configmap-$releaseName-$folder-titan-configs-envoy-lds.yaml" --set select="lds.yaml" > "$envoyconfigs/$folder/envoy/config/lds.yaml"
      if [[ $? -ne 0 ]]
      then
        echo "Failed at prepareEnvoyConfigurations - build lds.yaml step"
        exit 1
      fi
    fi
  done
  cd ..

}


# preCheck

# processAIOAdvance

prepareEnvoyConfigurations


