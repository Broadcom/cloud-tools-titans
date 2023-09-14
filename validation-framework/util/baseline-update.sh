#!/bin/bash
clone_prefix="https://github.gwd.broadcom.net/SED"
#for ssh use below configuration
#clone_prefix="git@github.gwd.broadcom.net:SED"
helm-baseline(){
	scm_root=$SCM_ROOT
  dir=$PWD
  chart_folder=$SCM_ROOT/tmp/charts
	if [ -z "$scm_root" ];then
    echo "\$SCM_ROOT not defined"
    exit
  # elif [ -z "$JFROGAUTH" ];then
  #   echo "\$JFROGAUTH not defined"
  #   exit
  fi
	 svc_inc_array=(
	 "icds-events"
	 "icds-identity"
	 "icds-user-directory"
	 "icds-r3"
	 "icds-user-messaging"
	 "icds-auth-management"
	 "icds-rules-manager"
	 )

	 svc_dev_array=(
 	 "icds-auth-management"
	 "icds-identity"
	 "icds-user-directory"
   "icds-global-catalog"
   "icds-customer-directory"
	 "icds-user-messaging"
	 "icds-events"
   "icds-caretaker"
   "icds-idp-service"
   "icds-user-service"
   "icds-workflow"
   "icds-saas-portal"
   "icds-provisioning"
   "icds-forza-portal"

   "icds-forza-notification"
   "icds-integration-app"
   "icds-news-article"

	#  "icds-r3"
	#  "icds-rules-manager"
	# 	"icds-spoc-notification"
  #  "icds-spoc"
  #  "icds-demo-app"
   )
  svc_legacy_baseline=(
 	  "icds-r3"
	  "icds-rules-manager"
	 	"icds-spoc-notification"
    "icds-spoc"
    "icds-demo-app"
  )
baseline_ver=""
	opt="status"
	if [ "$1" ];then
		opt="$1"
	fi

	if [ "$opt" = "help" ];then
		printf "options: status clean update force-fix increment push-branch package push-chart stage commit
		\n\tstage: \t\t
		-stashes existing changes in services
		-checks out latest from default branch
		-updates with latest baseline code"
		printf "\n\n\tcommit:
    \t\t-increments helm chart version
    \t\t-pushes branch and opens browser to create a pr
    \t\t-packages the helm chart
    \t\t-pushes helm chart to artifactory"
		printf "\noptions: status clean update force-fix increment push-branch package-chart push-chart stage commit"
		exit
	fi
	if [ "$opt" = "stage" ];then
		helm-baseline clean
		helm-baseline update
		helm-baseline force-fix
	elif [ "$opt" = "update-local-lib" ];then
		mkdir $scm_root/charts || echo "charts folder exists"
		cd $scm_root/cloud-tools-titans
		rm -rf $scm_root/icds-helm-service-baseline-lib/charts/*
		git pull || echo "failed to pull cloud-tools-titans"
		zsh scripts/package.sh && mv titan-mesh-helm-lib-chart-*.tgz $scm_root/icds-helm-service-baseline-lib/charts
		cd $scm_root/icds-helm-service-baseline-lib
		baseline_ver=$( grep '^version' Chart.yaml | sed 's/^.*: //' )
		rm -rf tmp
		git pull || echo "failed to pull baseline lib"
		zsh package.sh
		rm -rf $scm_root/charts/sbo-sps-helm-baseline-*
		cp sbo-sps-helm-baseline-${baseline_ver}.tgz $scm_root/charts/
		ls  $scm_root/charts/sbo-sps-helm-baseline-*
	elif [ "$opt" = "commit" ];then
#		helm-baseline increment
		helm-baseline push-branch
		helm-baseline clean
		helm-baseline package-chart
		helm-baseline push-chart
  elif [ "$opt" = "tme" ];then
    	 svc_dev_array=(
 	 "icds-symlib"
	 "icds-simplelib"
	 "icds-shared-libraries"
	 "icds-ingress"
	 "icds-common-libraries"

   )
	fi
	looper(){
		for service in  ${svc_array[*]} ;do
			if [ -d "$scm_root/$service" ];then
				cd $scm_root/$service || exit
#				echo "------------------$service -----------------------"
				if [ "$opt" = "update" ];then
					export hbu_branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
					git branch -D feature-update-baseline
					git checkout -b feature-update-baseline
					git remote add my-chart git@github.gwd.broadcom.net:SED/icds-helm-service-baseline-lib.git || true
					git subtree pull my-chart --prefix my-chart master -m "Pull latest common helm files from icds-helm-service-baseline-lib"
				elif [ "$opt" = "increment" ];then
					chart_version=$( grep '^version' my-chart/Chart.yaml | sed 's/^.*: //' |  awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
					sed -i '' 's/^version:.*/version: '"$chart_version"'/'  my-chart/Chart.yaml
					git add my-chart/Chart.yaml && git commit -a -m "increment helm chart version"
				elif [ "$opt" = "package-chart" ];then
					 helm package my-chart/ -d $chart_folder
 				elif [ "$opt" = "clean" ];then
 					git stash
 					git checkout $basebranch
# 					git fetch origin; git reset --hard origin/$basebranch
 					git pull
					git clean -fd
				elif [ "$opt" = "force-fix" ];then
					echo overwriting templates
					cp  $scm_root/icds-helm-service-baseline-lib/templates/*  my-chart/templates
					echo overwriting sidecars
					cp  $scm_root/icds-helm-service-baseline-lib/sidecars/*  my-chart/sidecars
					echo overwriting envoy
					cp  $scm_root/icds-helm-service-baseline-lib/envoy/*  my-chart/envoy
					echo overwriting configs
					cp  $scm_root/icds-helm-service-baseline-lib/configs/*  my-chart/configs
					git commit -a -m "fix helm chart baseline"
				elif [ "$opt" = "push-branch" ];then
					git add my-chart/Chart.yaml && git commit -m "update helm chart version"
					git push --set-upstream origin feature-update-baseline -f
#					git checkout $basebranch
					open git@github.gwd.broadcom.net:SED/$service/pull/new/feature-update-baseline
				elif [ "$opt" = "push-chart" ];then
					chart_version=$( grep '^version' my-chart/Chart.yaml | sed 's/^.*: //' )
					chart_name=$( grep '^name' my-chart/Chart.yaml | sed 's/^.*: //' )
					curl -H "X-JFrog-Art-Api:$JFROGAUTH" -T $chart_folder/${chart_name}-${chart_version}.tgz "https://artifactory-lvn.broadcom.net/artifactory/sbo-sps-helm-release-local/${chart_name}/${chart_name}-${chart_version}.tgz"
				elif [ "$opt" = "status" ];then
          echo "-------------    $service    ------------"
					git status
				elif [ "$opt" = "chart" ];then
					chart_version=$( grep '^version' my-chart/Chart.yaml | sed 's/^.*: //' )
					chart_name=$( grep '^name' my-chart/Chart.yaml | sed 's/^.*: //' )
					echo $chart_name:$chart_version
				elif [ "$opt" = "pr-ls" ];then
					echo git@github.gwd.broadcom.net:SED/$service/pulls
				elif [ "$opt" = "trigger-build" ];then
				  git commit --allow-empty -m "Trigger Build" && git push
				  echo "sleeping for 30 seconds"
				  sleep 30s
        elif [ "$opt" = "trigger-update" ];then
				  echo "-------------    $service    ------------"
				  if [ "$service" = "icds-user-directory" ];then
				    git checkout -b trigger-build && git commit --allow-empty -m "[skip-scans] Trigger Baseline Update" && git push --set-upstream origin trigger-build
				  else
				    git pull && git commit --allow-empty -m "[skip-scans] Trigger Baseline Update" && git push
				  fi
				  sleep 120s
        elif [ "$opt" = "tm" ];then
          echo "-------------    $service    ------------"
#					 git checkout feature-artifactory-change
#            git add .
#git commit -m "update references to artifactory-ren and artifactory-lvn"
#          git push --set-upstream origin feature-artifactory-change
          open $(git config --get remote.origin.url | sed 's/\.git/\/compare\/feature-artifactory-change\?expand\=1\&title\=Update%20Artifactory%20References/')
#            rg "artifactory-(ren|lvn)"
#            sed -E -i '' 's/artifactory-(ren|lvn)/packages/' **/Dockerfile
#            sed -E -i '' 's/artifactory-(ren|lvn)/packages/' my-chart/Chart.yaml
#            sed -E -i '' 's/artifactory-(ren|lvn)/packages/' resources/build-info.yaml
#            sed -E -i '' 's/artifactory-(ren|lvn)/packages/' **/pom.xml
#            sed -E -i '' 's/artifactory-(ren|lvn)/packages/' **/README.md
					# rm -r my-chart/charts
					# mkdir my-chart/charts
          # helm package my-chart/ -d $dir/charts


        elif [ "$opt" = "update-local-lib" ];then
          echo "-------------    $service    ------------"
          rm -rf my-chart/charts
          mkdir my-chart/charts || echo "charts folder exists"
          cp "$SCM_ROOT/charts/sbo-sps-helm-baseline-${baseline_ver}.tgz" my-chart/charts
          chart_name=$( grep '^name' my-chart/Chart.yaml | sed 's/^.*: //' )
          rm "$dir/charts/${chart_name}"*.tgz || echo "no $chart_name chart present to delete"
          helm package my-chart/ -d $dir/charts

        elif [ "$opt" = "tme" ];then
          echo "-------------    $service    ------------"



				elif [ "$opt" = "image-check" ];then
          image_name=$(sed -e '/    image:/,/  name:/!d' my-chart/values.yaml | grep name | sed 's/.*: //')
          image_version=$( grep '\&dockerTag .*' my-chart/Values.yaml | sed 's/.*\&dockerTag //' )
          if [ -z "$image_version" ];then
             image_version=$( grep '^      tag' my-chart/Values.yaml | sed 's/^.*: //' )
          fi
				  function docker_tag_exists() {
				    docker manifest inspect $image_name:$image_version > /dev/null
          }
          if docker_tag_exists; then
              echo exist
          else
              echo not exists
          fi
		    elif [ "$opt" = "image-ls" ];then
		      image_name=$(sed -e '/    image:/,/  name:/!d' my-chart/values.yaml | grep name | sed 's/.*: //')
          image_version=$( grep '\&dockerTag .*' my-chart/Values.yaml | sed 's/.*\&dockerTag //' )
          if [ -z "$image_version" ];then
             image_version=$( grep '^      tag' my-chart/Values.yaml | sed 's/^.*: //' )
          fi
#		      image_name=$( grep '^      name' my-chart/Values.yaml | sed 's/^.*: //' )
          echo "  sbo-sps-docker-release-local.artifactory-lvn.broadcom.net/sps-images/$image_name:$image_version"
				else
		    	echo unkown option: "$opt"
		    fi

			elif [ "$opt" = "clone" ];then
				cd $scm_root || exit
				  git clone "${clone_prefix}/$service.git"
			else
					echo unknown service:	$service
			fi
		done
	}
	echo performing $opt
	basebranch="develop"
	svc_array=("${svc_dev_array[@]}")
	looper
	if [ "$opt" = "clean" ];then
	  echo "-----------------updating mesh library"
 	  cd "$scm_root/cloud-tools-titans" || exit
    git stash
    git checkout develop
    git pull
    git clean -fd
	  echo "-----------------updating local baseline"
 	  cd "$scm_root/icds-helm-service-baseline-lib" || exit
    git stash
    git checkout develop
    git pull
    git clean -fd
  elif [ "$opt" = "clone" ];then
      cd $scm_root || exit
			git clone "${clone_prefix}/icds-helm-service-baseline-lib.git"
			git clone https://github.com/Broadcom/cloud-tools-titans.git
  fi
  cd $dir || exit

}
helm-baseline "$@"