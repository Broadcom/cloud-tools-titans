{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $ingress := $titanSideCars.ingress }}
  {{- $egress := $titanSideCars.egress }}
  {{- $service := .service }}
  {{- $validation := $titanSideCars.validation }}
  {{- $clusters := $validation.clusters | default dict }}
  {{- $envoy := $titanSideCars.envoy }}
  {{- $counter := 0 -}}
  {{- if or (hasKey $ingress "routes") (hasKey $egress "routes") }}

#!/bin/bash

# functions
credential="dGVzdDp0ZXN0"
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
  local JSON_FMT='{"privs":"%s","scope":"%s","roles":"%s","customer_id":"%s","domain_id":"%s","uri":"%s"}'
  local body=$(printf "$JSON_FMT" "$privs" "$scope" "$roles" "$cid" "$did" "$uri")
  jwt=""
  http_call "POST" "http://token-generator:8080/tokens" "" "" "$body"
  if [ "$code" == "200" ];
  then
    jwt=$(cat /tests/data/resp | jq -r '.access_token')
  fi
  # echo "jwt=$jwt"
}

# setup single trap
trap 'trp' SIGUSR1
trap 'trp' SIGTERM
trp() {
  echo "[`date -Is`] receive signal to exit" >> "/tests/logs/prox-health-check.log"
  exit 0
}

# health check
while :         
do
  healthCheck=$(curl --insecure --write-out '%{http_code}' --silent --output /dev/null -X GET "https://proxy:9443/healthz");
  if [ "$healthCheck" != "200" ];
  then
    echo "[`date -Is`] healthCheck: $healthCheck" >> "/tests/logs/prox-health-check.log"
  else
    break
  fi
  sleep 1        
done

get_token

expectedFailedCalls=0
expectedfailedTestChecks=0

testCalls=0
succeedCalls=0
failedCalls=0
testChecks=0
failedTestChecks=0
succeedTestChecks=0

    {{ if hasKey $ingress "routes" }}
# Process ingress routes
      {{- range $ingress.routes }}
        {{- $cluster := "proxy" }}
        {{- $route := .route }}
        {{- if $route }}
          {{- if $route.cluster }}
            {{- $cluster = $route.cluster }}
          {{- end }}
        {{- end }}
        {{- if or (eq $cluster "proxy") (and (ne $cluster "proxy") (hasKey $clusters $cluster)) }}
          {{- printf "# Ingress -> host:%s - path: %s\n" $cluster . }}
            {{- template "process_routing_validation" (dict "routing" . "cluster" $cluster "clusters" $clusters "direction" "ingress" "scheme" "https://proxy:9443" "respfile" "/tests/logs/resp.txt" "reportfile" "/tests/logs/report.txt") }}
          {{- $counter = add1 $counter -}}
        {{- end }}
      {{- end }}     
    {{- end }}

    {{ if hasKey $egress "routes" }}
# Process egress routes
      {{- range $egress.routes }}
        {{- $cluster := "proxy" }}
        {{- $route := .route }}
        {{- if $route }}
          {{- if $route.cluster }}
            {{- $cluster = $route.cluster }}
          {{- end }}
        {{- end }}
        {{- if or (eq $cluster "proxy") (and (ne $cluster "proxy") (hasKey $clusters $cluster)) }}
          {{- printf "# Egress -> host:%s - path: %s\n" $cluster . }}
          {{- template "process_routing_validation" (dict "routing" . "cluster" $cluster "clusters" $clusters "direction" "egress" "scheme" "http://proxy:9565" "respfile" "/tests/logs/resp.txt" "reportfile" "/tests/logs/report.txt") }}
          {{- $counter = add1 $counter -}}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- printf "echo \"Summary:\" >> \"/tests/logs/report.txt\"\n" }}
  {{- printf "echo \"  Completed $testCalls test calls\" >> \"/tests/logs/report.txt\"\n" }}
  {{- printf "echo \"    Succeed $succeedCalls test calls\" >> \"/tests/logs/report.txt\"\n" }}
  {{- printf "echo \"    Failed $failedCalls test calls\" >> \"/tests/logs/report.txt\"\n" }}
  {{- printf "echo \"  Completed $testChecks test checks\" >> \"/tests/logs/report.txt\"\n" }}
  {{- printf "echo \"    Succeed $succeedCalls test checks\" >> \"/tests/logs/report.txt\"\n" }}
  {{- printf "echo \"    Failed $failedTestChecks test checks\" >> \"/tests/logs/report.txt\"\n" }}
  if [ "$failedCalls" == "$expectedFailedCalls" ] && [ "$failedTestChecks" == "$expectedfailedTestChecks" ]
  then
    exit 0
  else
    exit 1
  fi

{{- end }}

{{- define "process_routing_validation" -}}
  {{- $routing := .routing -}}
  {{- $clusters := .clusters -}}
  {{- $cluster := .cluster -}}
  {{- $respfile := .respfile -}}
  {{- $direction := .direction -}}
  {{- $reportfile := .reportfile -}}
  {{- if $routing -}}
    {{- $scheme := .scheme -}}
    {{- $rtest := false -}}
    {{- if eq $direction "ingress" -}}
      {{- if hasKey $routing "route" -}}
        {{- $rtest = true -}}
      {{- end -}}
    {{- else if eq $direction "egress" -}}
      {{- $rtest = true -}}
    {{- end -}}
    {{- if $rtest -}}
      {{- if $routing.match -}}
        {{- template "validate_routing_curl_jq_cmds" (dict "routing" $routing "cluster" $cluster "clusters" $clusters "scheme" $scheme "respfile" $respfile "reportfile" $reportfile) -}}
      {{- else if $routing.route -}}
        {{- $route := $routing.route -}}
        {{- if and $route.cluster $clusters -}}
          {{- $clusteValue := index $clusters $route.cluster -}}
          {{- if $clusteValue }}
            {{- range $clusteValue.routes }}
              {{- template "validate_routing_curl_jq_cmds" (dict "routing" . "cluster" $cluster "clusters" $clusters "scheme" $scheme "respfile" $respfile "reportfile" $reportfile) -}}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}


{{- define "validate_routing_curl_jq_cmds" -}}
  {{- $routing := .routing -}}
  {{- $respfile := .respfile -}}
  {{- $reportfile := .reportfile -}}
  {{- $cluster := .cluster -}}
  {{- $scheme := .scheme -}}
  {{- $path := "" -}}
  {{- $cmd := "" -}}
  {{- $method := "GET" -}}
  {{- $headers := dict -}}
  {{- if hasKey $routing "match" -}}
    {{- $supported := true }}
    {{- $tokenCheck := $routing.tokenCheck | default false }}
    {{- $authType := "Bearer" }}
    {{- $match := $routing.match -}}
    {{- if hasKey $match "method" -}}
      {{- $method = $match.method -}}
    {{- end -}}
    {{- if hasKey $match "prefix" -}}
      {{- $path = printf "%s/abc" (trimSuffix "/" $match.prefix) -}}
    {{- else if hasKey $match "path" -}}
      {{- $path = printf "%s" $match.path -}}
    {{- else if hasKey $match "regex" -}}
      {{/* $path = randomRegex $match.regex */}}
      {{- $supported = false }}
    {{- end -}}
    {{- if $supported }}
      {{- if hasKey $match "headers" -}}
        {{- range $match.headers -}}
          {{- $key := .key -}}
          {{- $val := "" -}}
          {{- if eq $key "Authorization" -}}
            {{- if hasPrefix "Basic" .sw -}}
              {{- $authType = "Basic" }}
              {{/* {{- $val = printf "Basic %s" (b64enc "test:test") -}} */}}
            {{- end -}}
            {{- $tokenCheck = true }}
          {{- else if hasKey . "eq" -}}
            {{- $val = .eq -}}
          {{- else if hasKey . "sw" -}}
            {{- $val = printf "%s%s" .sw (randAscii 5) -}}          
          {{- else if hasKey . "ew" -}}
            {{- $val = printf "%s%s" (randAscii 5) .ew -}}             
          {{- else if hasKey . "co" -}}
            {{- $val = printf "%s%s%s" (randAscii 5) .co (randAscii 5) -}}              
          {{- else if hasKey . "lk" -}}
            {{/*- $val = randomRegex .lk -*/}}
          {{- else if hasKey . "pr" -}}
            {{- if .pr -}}
              {{- $val = "def" -}}          
            {{- end }}
          {{- else if hasKey . "neq" -}}
            {{- $val = printf "%s%s" .neq (randAscii 5) -}}          
          {{- else if hasKey . "nsw" -}}
            {{- $val = printf "%s%s" (randAscii 5) .nsw -}}          
          {{- else if hasKey . "new" -}}
            {{- $val = printf "%s%s" .new (randAscii 5) -}} 
          {{- else if hasKey . "nco" -}}
            {{- $val = printf "%s" (randAscii 5) -}} 
          {{- else if hasKey . "nlk" -}}
          {{/* {{- $val = printf "%s" (randAscii 5) -}}  */}}
          {{- end -}}
          {{- if ne $val "" -}}
            {{- if eq $key ":path" -}}
              {{- $path = $val -}}
            {{- else if eq $key ":method" -}}
              {{- if .eq }}
                {{- $method = upper .eq -}}
              {{- else if .neq -}}
                {{- $neq := upper .neq -}}
                {{- if ne "GET" $neq -}}
                  {{- $method = $neq -}}
                {{- else if ne "POST" $neq -}}
                  {{- $method = $neq -}}
                {{- else if ne "PUT" $neq -}}
                  {{- $method = $neq -}}
                {{- else if ne "DELETE" $neq -}}
                  {{- $method = $neq -}}
                {{- else if ne "PATCH" $neq -}}
                  {{- $method = $neq -}}
                {{- end -}}
              {{- end }}
            {{- else -}}
              {{- $_ := set $headers $key $val -}}
            {{- end -}}
          {{- end -}}
        {{- end }}
      {{- end }}
      {{- $hdrStr := "" }}
      {{- range $k, $v := $headers -}}
          {{- if eq  $hdrStr "" -}}
            {{- $hdrStr = printf "-H %s:%s" $k $v -}}
          {{- else -}}
            {{- $hdrStr = printf "%s %s:%s" $hdrStr $k $v -}}
          {{- end -}}
      {{- end -}}
      {{- if $tokenCheck }}
      {{/* perform RBAC process here
      {{- printf "get_token %s %s %s\n" ($privs | quote) ($scope | quote) ($role | squote) -}} */}}
        {{- printf "http_call %s %s %s %s\n" ($method | quote) (printf "%s%s" $scheme $path | quote) (printf "%s" $hdrStr | squote) (printf "%s" $authType | quote) -}}
      {{- else }}
        {{- printf "http_call %s %s %s\n" ($method | quote) (printf "%s%s" $scheme $path | quote) (printf "%s" $hdrStr | squote) -}}
      {{- end }}
      {{- printf "((testCalls=testCalls+1))\n" }}
      {{- if hasKey $routing "redirect" -}}
        {{- $redirect := $routing.redirect -}}
        {{- printf "  if [ \"$code\" != \"%s\" ]\n" ($redirect.responseCode | default "301") -}}
        {{- printf "  then\n" -}}
        {{- printf "    ((failedCalls=failedCalls+1))\n" }}
        {{- printf "    echo \"Failed at cmd[%s %s%s]\" >> %s\n" $method $scheme $path $reportfile -}}
        {{- printf "    echo \"  headers:%s\" >> %s\n" $headers $reportfile -}}
        {{- printf "    echo \"    expect: status code[%s], but got status code[$code]\" >> %s\n" $redirect.responseCode $reportfile -}}
        {{- printf "  else\n" -}}
        {{- printf "    echo \"Succeed at cmd[%s]\" >> %s\n" $cmd $reportfile -}}
        {{- printf "    ((succeedCalls=succeedCalls+1))\n" }}
        {{- printf "  fi\n" -}}
      {{- else if hasKey $routing "directResponse" -}}
        {{- $directResponse := $routing.directResponse -}}
        {{- printf "  if [ \"$code\" != \"%s\" ]\n" $directResponse.status -}}
        {{- printf "  then\n" -}}
        {{- printf "    ((failedCalls=failedCalls+1))\n" }}
        {{- printf "    echo \"Failed at cmd[%s %s%s]\" >> %s\n" $method $scheme $path $reportfile -}}
        {{- printf "    echo \"  headers:%s\" >> %s\n" $headers $reportfile -}}
        {{- printf "    echo \"    expect: status code[%s], but got status code[$code]\" >> %s\n" $directResponse.status $reportfile -}}
        {{- printf "  else\n" -}}
        {{- printf "    echo \"Succeed at cmd[%s]\" >> %s\n" $cmd $reportfile -}}
        {{- printf "    ((succeedCalls=succeedCalls+1))\n" }}
        {{- printf "  fi\n" -}}
      {{- else if hasKey $routing "route" -}}
        {{- $route := $routing.route -}}
        {{- printf "  if [ \"$code\" != \"200\" ]\n" -}}
        {{- printf "  then\n" -}}
        {{- printf "    ((failedCalls=failedCalls+1))\n" }}
        {{- printf "    echo \"Failed at cmd[%s %s%s]\" >> %s\n" $method $scheme $path $reportfile -}}
        {{- printf "    echo \"  headers:%s\" >> %s\n" $headers $reportfile -}}
        {{- printf "    echo \"    expect: status code[200], but got status code[$code]\" >> %s\n" $reportfile -}}
        {{- printf "  else\n" -}}
        {{- printf "    ((succeedCalls=succeedCalls+1))\n" }}
        {{- if hasKey $route "prefixRewrite" -}}
          {{- printf "    path=$(echo $resp | jq -r '.http.originalUrl')\n" -}}
          {{- printf "    ((testChecks=testChecks+1))\n" }}
          {{- printf "    if [[ $path != *\"%s\"* ]]\n" $route.prefixRewrite -}}
          {{- printf "    then\n" -}}
          {{- printf "      ((failedTestChecks=failedTestChecks+1))\n" }}
          {{- printf "      echo \"Failed at cmd[%s %s%s]\" >> %s\n" $method $scheme $path $reportfile -}}
          {{- printf "      echo \"  headers:%s\" >> %s\n" $headers $reportfile -}}
          {{- printf "      echo \"    expect: prefix path[%s], but got path[$path]\" >> %s\n" $route.prefixRewrite $reportfile -}}
          {{- printf "    else\n" }}
          {{- printf "      ((succeedTestChecks=succeedTestChecks+1))\n" }}
          {{- printf "    fi\n" -}}
        {{- end -}}
        {{- printf "    host=$(echo $resp | jq -r '.host.hostname')\n" }}
        {{- printf "    if [ \"$host\" != \"%s\" ]\n" $cluster -}}
        {{- printf "    then\n" -}}
        {{- printf "      ((failedTestChecks=failedTestChecks+1))\n" }}
        {{- printf "      echo \"Failed at cmd[%s %s%s]\" >> %s\n" $method $scheme $path $reportfile -}}
        {{- printf "      echo \"  headers:%s\" >> %s\n" $headers $reportfile -}}
        {{- printf "      echo \"    expect: route to host[%s], but got host[$host]\" >> %s\n" $cluster $reportfile -}}
        {{- printf "    else\n" }}
        {{- printf "      ((succeedTestChecks=succeedTestChecks+1))\n" }}
        {{- printf "    fi\n" -}}
        {{- printf "  fi\n" -}}    
      {{- else -}}
        {{- printf "  if [ \"$code\" != \"200\" ]\n" -}}
        {{- printf "  then\n" -}}
        {{- printf "    ((failedCalls=failedCalls+1))\n" }}
        {{- printf "    echo \"Failed at cmd[%s %s%s]\" >> %s\n"  $method $scheme $path $reportfile -}}
        {{- printf "    echo \"    expect: status code[200], but got status code[$code]\" >> %s\n" $reportfile -}}
        {{- printf "  else\n" -}}
        {{- printf "    ((succeedCalls=succeedCalls+1))\n" }}
        {{- printf "    host=$(echo $resp | jq -r '.host.hostname')\n" -}}
        {{- printf "    ((testChecks=testChecks+1))\n" }}
        {{- printf "    if [ \"$host\" != \"%s\" ]\n" $cluster -}}
        {{- printf "    then\n" -}}
        {{- printf "      ((failedTestChecks=failedTestChecks+1))\n" }}
        {{- printf "      echo \"Failed at cmd[%s %s%s]\" >> %s\n" $method $scheme $path $reportfile -}}
        {{- printf "      echo \"  headers:%s\" >> %s\n" $headers $reportfile -}}
        {{- printf "      echo \"    expect: route to host[%s], but got host[$host]\" >> %s\n" $cluster $reportfile -}}
        {{- printf "    else\n" }}
        {{- printf "      ((succeedTestChecks=succeedTestChecks+1))\n" }}
        {{- printf "    fi\n" -}}
        {{- printf "  fi\n" -}}
      {{- end -}}
    {{- end }}
  {{- end -}}
{{- end -}}