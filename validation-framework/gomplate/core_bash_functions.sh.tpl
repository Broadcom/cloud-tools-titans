{{- define "validation_bash_core_functions" -}}
# functions
credential="dGVzdDp0ZXN0"
declare -A validation_array
tokenGeneratorUrl="http://token-generator:8080/tokens"
lookupresult=""
testname=""

function http_call() {
  local method=$1
  local url=$2
  local headers=$3
  local authtype=$4
  local data=$5
  local tokencall=$6
  local insecure=""
  
  code=0
  resp=""
  respheaders=""

  [ -f "/tests/data/resp" ] && rm /tests/data/resp
  [[ $url == "https://"* ]] && insecure="--insecure"
  [[ $tokencall != "true" ]] && ((testCalls=testCalls+1))

  if [ -z "$authtype" ]
  then
    if [ -z "$data" ]
    then
      # echo "No auth and no data"
      code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method "$url");
    else
      # echo "No auth and has data"
      code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method -d "$data" "$url");
    fi
  else
    if [[ $authtype == "Bearer" ]]
    then
      if [ -z "$data" ]
      then
        # echo "Bearer auth and no data"
        code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Bearer $jwt" -X $method "$url");
      else
        # echo "Bearer auth and has data"
        code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Bearer $jwt" -X $method -d "$data" "$url");
      fi
    else
      if [ -z "$data" ]
      then
        # echo "Basic auth and no data"      
        code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Basic $credential" -X $method "$url");
      else
        # echo "Basic auth and has data"   
        code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method -d "$data" "$url");
      fi
    fi
  fi
  {{/* [ -z "$tokencall" ] && ((testCalls=testCalls+1)) */}}
  process_http_response
  {{/* resp=$(cat /tests/data/resp); */}}
}

function process_http_response() {
  OUTPUT="$(cat /tests/data/resp | tr -d '\r')"
  is_header=true
  is_first_line=true
  is_beyond_second_line=false
  body=""
  [ -f "/tests/data/resp_headers" ] && rm /tests/data/resp_headers
  [ -f "/tests/data/resp_body" ] && rm /tests/data/resp_body
  echo "${OUTPUT}" | while read -r LINE; do
    if ${is_first_line}; then
        # protocol="$(echo "${LINE}" | cut -d' ' -f1)"
        # code="$(echo "${LINE}" | cut -d' ' -f2)"
        echo -n "{" > /tests/data/resp_headers
        is_first_line=false

    elif ${is_header}; then
        if ${is_beyond_second_line}; then
          if test -n "${LINE}"; then
            echo -n "," >> /tests/data/resp_headers
          fi
        fi
        if test -n "${LINE}"; then
            key="$(echo "${LINE}" | cut -d: -f1)"
            val="$(echo "${LINE}" | cut -d: -f2- | sed 's/"/\\"/g')"
            echo -n "\"${key}\": \"${val:1}\""  >> /tests/data/resp_headers
        else
            is_header=false
        fi
        is_beyond_second_line=true
    else
      echo -n '}'  >> /tests/data/resp_headers
      echo -n "${LINE}" > /tests/data/resp_body
    fi
  done
  resp=$(cat /tests/data/resp_body);
  respheaders=$(cat /tests/data/resp_headers);
}

function get_token() {
  local privs="authentication"
  local scope="system"
  local roles="<test::administrator>"
  local cid="test_customer"
  local did="test_domain"
  local uri="/user-directory/v1/users/abcdef"
  local clid="O2ID.test_customer.test_domain.abcdef"
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
  http_call "POST" "$tokenGeneratorUrl" "" "" "$body" "true"
  if [ "$code" == "200" ];
  then
    jwt=$(echo $resp| jq -r '.access_token')
  fi
  # echo "jwt=$jwt"
}

function check_test_call() {
  if [[ -z "$1" ]]
  then
    echo "Missing test name - test will be skipped" >> /tests/logs/error.log
    ((skippedTestChecks=skippedTestChecks+1))
  else
    local expectcode="200"
    local expectop="eq"
    testname=$1
    test_result="succeed"
    [[ ! -z "$2" ]] && expectcode=$2
    [[ ! -z "$3" ]] && expectop=$3
    ((testChecks=testChecks+1))
    if [[ $expectop == "eq" ]]
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
    elif [[ $expectop == "ne" ]]
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
    elif [[ $expectop == "in" ]]
    then
      local items=(${expectcode//,/ })
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
      echo "Unsupported operator $expectop for value $expectcode" 
    fi
  fi
}

function test_check() {
  if [[ $test_result !=  "succeed" ]]
  then
    echo "Skip this test check due to previous test check failed" >> /tests/logs/error.log
    ((skippedTestChecks=skippedTestChecks+1))
  else
    local expectvalue=""
    local expectop="eq"
    test_result="succeed"
    [[ ! -z "$1" ]] && expectvalue=$1
    [[ ! -z "$2" ]] && expectop=$2
    if [ -z "$lookupresult" ]
    then
      if [[ $expectop != "npr" ]]
      then
        ((failedTestChecks=failedTestChecks+1))
        test_result="failed"
      else
        ((succeedTestChecks=succeedTestChecks+1))
      fi
    else
      if [[ $expectop == "eq" ]]
      then
        if [[ $expectvalue == $lookupresult ]] 
        then
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ $expectop == "ne" ]]
      then
        if [[ $expectvalue != $lookupresult ]] 
        then
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ $expectop == "co" ]]
      then
        if [[ $lookupresult == *"$expectvalue"* ]] 
        then
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ $expectop == "prefix" ]]
      then
        if [[ $lookupresult == "expectvalue"* ]] 
        then
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ $expectop == "suffix" ]]
      then
        if [[ $lookupresult == *"expectvalue" ]] 
        then
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      else
        echo "Unsupported oprand $expectop for $expectvalue"
          ((badTestChecks=badTestChecks+1))
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
      fi
    fi
  fi
}

function check_and_report() {
  local key
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
      local val
      if [[ "$key" == *"."* ]] 
      then
        local harr=(${key//./ })
        if [[ ${harr[0]} == "headers" ]]
        then
          local hprefix="headers."
          local hkey=${key#"$hprefix"}
          hkey=$(echo ".\"$hkey\"")
          val=$(echo $respheaders | jq -r $hkey)
        else
          val=$(echo $resp | jq -r $key) 
        fi
      else
        local dstr=$(echo $key | base64 -d)
        if [ -z "$dstr"]
        then
          echo "Unable to do base64 decode"
        else
          val=$(echo $resp | jq -r $dstr)
        fi
      fi
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

