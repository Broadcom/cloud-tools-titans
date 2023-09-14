#!/bin/bash
scm_root=$SCM_ROOT
dir=$PWD
if [ -z "$scm_root" ];then
  echo "\$SCM_ROOT not defined"
  exit
fi
working_dir="$scm_root/icds-all-in-one"
	env="dev-stage"
	if [ "$1" ];then
		env="$1"
	fi
	par="sp1"
	if [ "$2" ];then
		par="$2"
	fi
cd "$working_dir"
#helm template . --output-dir "$working_dir/tmp/dev-stage" -f deployment/dev-stage/sp1/additional-values/values.yaml -f deployment/dev-stage/sp1/additional-values/values-services-override.yaml -f deployment/dev-stage/sp1/additional-values/values-par-override.yaml -f deployment/dev-stage/sp1/additional-values/values-env-override.yaml -f deployment/dev-stage/sp1/additional-values/values-jetstream-override.yaml -f deployment/dev-stage/sp1/additional-values/values-ingress-override.yaml -f deployment/dev-stage/sp1/additional-values/values-override.yaml
#cd "$dir"
if [ "$env" = "dev-stage" ];then
  cluster="gkesharedicd"
elif [ "$env" = "validation" ];then
  cluster="gkesharedicd"
elif [ "$env" = "dev" ];then
  cluster="gdu1"
elif [ "$env" = "verify1" ];then
  cluster="svcstussaasgke1"
elif [ "$env" = "verify2" ];then
  cluster="svcstussaasgke1"
elif [ "$env" = "prod1" ];then
  cluster="spcstg1saasgke1"
elif [ "$env" = "prod2" ];then
  cluster="spcstg1saasgke1"
fi
if [[ -d "$working_dir/deployment/$env" ]]; then
  vals=""
  if [ -f "$working_dir/deployment/$env/$cluster/commands.yml" ]; then
    vals=$(grep "^$par\:" "$working_dir/deployment/$env/$cluster/commands.yml" | sed 's/'$par'\: //')
  else
    vals=$(grep "^$par\:" "$working_dir/deployment/$env/commands.yml" | sed 's/'$par'\: //')
  fi
  vargs=($(echo "$vals" | tr " " "\n") "")
  rm -rf "$working_dir/tmp/$env/$par"
  helm template icds-${env}-release . --debug --output-dir "$working_dir/tmp/$env/$par" -n sedicdsaas-${env}-sp1 ${vargs[@]/#/}
else
  echo "env $env does not exist"
fi