#!/bin/bash




envUpdate(){
	scm_root=$SCM_ROOT
	deploy_root="$scm_root/icds-all-in-one/deployment/"
  dir=$PWD
  chart_folder=$SCM_ROOT/tmp/charts
  common_folder="$deploy_root/common"
	if [ -z "$scm_root" ];then
    echo "\$SCM_ROOT not defined"
    exit
  elif [ -z "$JFROGAUTH" ];then
    echo "\$JFROGAUTH not defined"
    exit
  fi
	 folders=(
#    "dev"
#    "dev-stage"
    "snapshot"
#    "verfiy1"
#    "verify2"
#    "load"
#    "verify-failover"
	 )
	 virtualFolders=(
    "integration"
    "verify"
    "prod"
	 )
	 partitions=(
    "cp1"
    "sp1"
    "cp2"
    "spoc"
	 )

	opt="status"
	if [ "$1" ];then
		opt="$1"
	fi
if [ "$opt" = "status" ];then
            git status
            exit
fi
	looper(){
		for env in ${folders[*]} ;do
		  for partition in ${partitions[*]} ;do
		    part_folder="$deploy_root/$env/$partition"
        if [ -d "$part_folder" ];then
          cd $part_folder || exit
          echo "------------------$env/$partition -----------------------"
          default_release="sedicdsaas-$env-release"
          if [ "$opt" = "bootstrap-values" ];then
            mkdir -p additional-values
            if [ -f values.yaml ];then
              mv values.yaml additional-values/values-override.yaml
            fi
            if [ ! -f push-images.yml ];then
              touch push-images.yml
            fi
            common_vals=(
            "values.yaml"
            "values-${partition}-override.yaml"
            "values-ingress-override.yaml"
            "values-services-override.yaml"
            "values-jetstream-override.yaml"
            )
            applied_vals=()
            for vals in  ${common_vals[*]} ;do
              if [ -f "../../common/$vals" ]; then
                applied_vals+=("$vals")
                ln -s "../../../common/$vals" "additional-values/$vals"
              elif [ -f "../../common/${partition}/$vals" ]; then
                applied_vals+=("$vals")
                ln -s "../../../common/${partition}/$vals" "additional-values/$vals"
              fi
            done
            if [ -f helm-command.yml ];then
              sed -i '' 's/^values: .*/values: .\/additional-values\/values.yaml/' helm-command.yml
              if  grep -q 'valuesFiles' helm-command.yml ;then
                sed -i '' "s/valuesFiles: .*//" helm-command.yml
              fi
              valuesOpts=$(echo ${applied_vals[*]} | sed "s/ / -f \/values\//g")
              echo "valuesFiles: -f /values/$valuesOpts -f values-override.yaml" >> helm-command.yml
            fi
          elif [ "$opt" = "chart" ];then
            if [ -f helm-command.yml ];then
              sed -i '' 's/^values: .*/values: .\/additional-values\/values.yaml/' helm-command.yml
              if  grep -q 'valuesFiles' helm-command.yml ;then
                sed -i '' "s/valuesFiles: .*//" helm-command.yml
              fi
              appliedVals=$(ls additional-values)
              valuesOpts=$(echo ${applied_vals[*]} | sed "s/ / -f \/values\//g")
              echo "valuesFiles: -f /values/$valuesOpts -f values-override.yaml" >> helm-command.yml
            fi
          elif [ "$opt" = "chart" ];then
            chart_version=$( grep '^version' my-chart/Chart.yaml | sed 's/^.*: //' )
            chart_name=$( grep '^name' my-chart/Chart.yaml | sed 's/^.*: //' )
            echo $chart_name:$chart_version
        else
            echo unknown service:	$service
        fi
      fi
			done
		done
	}
	echo performing $opt
	basebranch="develop"
	svc_array=("${svc_dev_array[@]}")
	looper
  cd $dir || exit

}
envUpdate "$@"