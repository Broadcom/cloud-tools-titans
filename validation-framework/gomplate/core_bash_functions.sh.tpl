{{- define "validation_bash_core_functions" -}}
# functions
credential="dGVzdDp0ZXN0"
declare -A validation_array
tokenGeneratorUrl="http://token-generator:8080/tokens"

function http_call() {
  local method=$1
  local url=$2
  local headers=$3
  local authtype=$4
  local data=$5
  local insecure=""
  
  code=0
  resp=""

  [ -f "/tests/data/resp" ] && rm /tests/data/resp
  [[ $url == "https://"* ]] && insecure="--insecure"

  if [ -z "$authtype" ]
  then
    if [ -z "$data" ]
    then
      # echo "No auth and no data"
      code=$(curl $insecure --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method "$url");
    else
      # echo "No auth and has data"
      code=$(curl $insecure --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method -d "$data" "$url");
    fi
  else
    if [[ $authtype == "Bearer" ]]
    then
      if [ -z "$data" ]
      then
        # echo "Bearer auth and no data"
        code=$(curl $insecure --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Bearer $jwt" -X $method "$url");
      else
        # echo "Bearer auth and has data"
        code=$(curl $insecure --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Bearer $jwt" -X $method -d "$data" "$url");
      fi
    else
      if [ -z "$data" ]
      then
        # echo "Basic auth and no data"      
        code=$(curl $insecure --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Basic $credential" -X $method "$url");
      else
        # echo "Basic auth and has data"   
        code=$(curl $insecure --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method -d "$data" "$url");
      fi
    fi
  fi
  {{/* [ -z "$tokencall" ] && ((testCalls=testCalls+1)) */}}
  resp=$(cat /tests/data/resp);
}

function get_token() {
  local privs="assign_any_role_member core_internal_access create_customer_token create_idp_user create_orders create_system_token create_users delete_events delete_users deprovision_customer domain_remapping edit_users enroll_devices epmp_internal_access extend_licenses file_upload icds:maint:purge login manage_adsync_jobs manage_customer manage_devices manage_domain manage_domain_status manage_domain_subscription manage_groups manage_licenses manage_org_units manage_organization manage_products manage_services manage_subscription manage_support_notification manage_tenant_remap manage_user_profiles manage_users oauth_client_mgmt provision_customer provision_users read_all_organizations read_any_role read_organization read_workflow require_second_factor_auth retry_workflow saas_create_customer saas_manage_workflow scan_all_users send_user_message support_view_news_article unblock_bounced_email update_account_default use_licenses usvc_search_login view_access_profile view_customers view_domain view_domain_subscription view_events view_external_idp view_groups view_idp view_idp_user view_org_units view_products view_roles view_services view_subscriptions view_system_registry view_user_profiles view_users view_utilization write_roles write_user_profiles write_users write_workflow"
  local scope="system"
  local roles="<secc::administrator>"
  local cid="test_customer"
  local did="test_domain"
  local uri="/user-directory/v1/users/gfsdhjfgal"
  [[ ! -z "$1" ]] && privs=$1
  [[ ! -z "$2" ]] && scope=$2
  [[ ! -z "$3" ]] && roles=$3
  [[ ! -z "$4" ]] && cid=$4
  [[ ! -z "$5" ]] && did=$5
  [[ ! -z "$6" ]] && uri=$6
  [[ ! -z "$7" ]] && clid=$7
  
  local JSON_FMT='{"privs":"%s","scope":"%s","roles":"%s","customer_id":"%s","domain_id":"%s","uri":"%s","client_id":"%s"}'
  local body=$(printf "$JSON_FMT" "$privs" "$scope" "$roles" "$cid" "$did" "$uri" "$clid")
  jwt=""
  http_call "POST" "$tokenGeneratorUrl" "" "" "$body"
  if [ "$code" == "200" ];
  then
    jwt=$(cat /tests/data/resp | jq -r '.access_token')
  fi
  # echo "jwt=$jwt"
}

function check_and_report() {
  local key
  ((testCalls=testCalls+1))
  ((testChecks=testChecks+1))
  test_result="succeed"
  for key in "${!validation_array[@]}"
  do
    local estr=${validation_array[$key]}
    local arr=(${estr//:::/ })
    # echo "${validation_array[$key]}"
    if [ "$key" == "code" ]
    then
      # echo "key=$key"
      if [[ ${arr[0]} == "eq" ]]
      then
        if [[ $code -eq ${arr[1]} ]]
        then
          ((succeedCalls=succeedCalls+1))
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedCalls=failedCalls+1))
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ ${arr[0]} == "ne" ]]
      then
        if [[ $code -ne ${arr[1]} ]]
        then
          ((succeedCalls=succeedCalls+1))
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedCalls=failedCalls+1))
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ ${arr[0]} == "in" ]]
      then
        local val=${arr[1]}
        local items=(${val//,/ })
        local found="false"
        local t
        for t in ${items[@]}; do
          [[ $code -ne $t ]] && found="true"
        done
        if [ "$found" == "true" ]
        then
          ((succeedCalls=succeedCalls+1))
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedCalls=failedCalls+1))
          ((failedTestChecks=failedTestChecks+1))
        fi
      else
        echo "Unsupported operator ${arr[0]} for value ${arr[1]}" 
      fi
    else
      # echo "$key pass format check"
      local val=$(echo $resp | jq -r $key)
      # echo "got $key=$val"
      if [ -z "$val" ]
      then
        echo "Check failed - missing request key: $key"
        if [[ ${arr[0]} != "npr" ]]
        then
          ((failedTestChecks=failedTestChecks+1))
          echo "Check failed - missing request key: $key"
          test_result="failed"
        else
          ((succeedTestChecks=succeedTestChecks+1))
          # echo "succeedTestChecks=$succeedTestChecks"
        fi
      else
      # {{/* if [[ ${validation_array[$key]} == ".http."* || $key == ".request.headers."* || $key == ".request.body."* ]] */}}
        if [[ ${arr[0]} == "eq" ]]
        then
          # echo "${arr[0]} eq ${arr[1]}"
          if [[ ${arr[1]} == $val ]] 
          then
            ((succeedTestChecks=succeedTestChecks+1))
            # echo "succeedTestChecks=$succeedTestChecks"   
            # echo "$key[${arr[1]}] == $val"         
          else
            ((failedTestChecks=failedTestChecks+1))
            echo "Check failed - $key[${arr[1]}] != $val"
            echo "failedTestChecks=$failedTestChecks"
            test_result="failed"
          fi
        elif [[ ${arr[0]} == "ne" ]]
        then
          # echo "${arr[0]} ne ${arr[1]}"
          if [[ ${arr[1]} != $val ]] 
          then
            ((succeedTestChecks=succeedTestChecks+1))
            # echo "succeedTestChecks=$succeedTestChecks"   
            # echo "$key[${arr[1]}] != $val"         
          else
            ((failedTestChecks=failedTestChecks+1))
            # echo "failedTestChecks=$failedTestChecks"
            test_result="failed"
          fi
        elif [[ ${arr[0]} == "co" ]]
        then
          # echo "${arr[0]} co ${arr[1]}"
          if [[ $val == *"${arr[1]}"* ]] 
          then
            ((succeedTestChecks=succeedTestChecks+1))
            # echo "succeedTestChecks=$succeedTestChecks"   
            # echo "$val conatns $key[${arr[1]}]"         
          else
            ((failedTestChecks=failedTestChecks+1))
            echo "Check failed - $val does not contain $key[${arr[1]}]"
            echo "failedTestChecks=$failedTestChecks"
            test_result="failed"
          fi
        elif [[ ${arr[0]} == "prefix" ]]
        then
          # echo "${arr[0]} prefix ${arr[1]}"
          if [[ $val == "${arr[1]}"* ]] 
          then
            ((succeedTestChecks=succeedTestChecks+1))
            # echo "succeedTestChecks=$succeedTestChecks"   
            # echo "$val hasPrefix $key[${arr[1]}]"         
          else
            ((failedTestChecks=failedTestChecks+1))
            echo "Check failed - $val does not havePrefix $key[${arr[1]}]"
            echo "failedTestChecks=$failedTestChecks"
            test_result="failed"
          fi
        elif [[ ${arr[0]} == "suffix" ]]
        then
          # echo "${arr[0]} suffix ${arr[1]}"
          if [[ $val == *"${arr[1]}" ]] 
          then
            ((succeedTestChecks=succeedTestChecks+1))
            # echo "succeedTestChecks=$succeedTestChecks"   
            # echo "$val hasPrefix $key[${arr[1]}]"         
          else
            ((failedTestChecks=failedTestChecks+1))
            echo "Check failed - $val does not haveSuffix $key[${arr[1]}]"
            echo "failedTestChecks=$failedTestChecks"
            test_result="failed"
          fi
        else
          echo "Unsupported oprand ${arr[0]} for ${arr[1]}"
            ((badTestChecks=badTestChecks+1))
            ((failedTestChecks=failedTestChecks+1))
            test_result="failed"
        fi
      fi
    fi
    # echo "$key => ${validation_array[$key]}" 
  done
  # if [[ $code -ge 200 && $code -lt 300 ]]
  # then
  #   echo "Got 2XX"
  #   for key in "${!validation_array[@]}"
  #   do
  #     echo "$key => ${validation_array[$key]}" 
  #   done
  # elif [[ $code -ge 300 && $code -lt 400 ]]
  # then
  #   echo "Got 3XX"
  #   for key in "${!validation_array[@]}"
  #   do
  #     echo "$key => ${validation_array[$key]}" 
  #   done
  # elif [[ $code -ge 400 && $code -lt 500 ]]
  # then
  #   echo "Got 4XX"
  # else  [[ $code -ge 500 ]]
  #   echo "Got 5XX"
  # fi
}
{{- end -}}

