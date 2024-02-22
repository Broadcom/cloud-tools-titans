{{- define "validation_bash_core_functions" -}}
# functions
{{/* set -e */}}
credential="dGVzdDp0ZXN0"
tokenServiceUrl="http://token-generator:8080/tokens"
lookupresult=""
testCallInfo=""
expectedQueryPath=""
{{/* testname="" */}}

function http_call() {
  local method=$1
  local url=$2
  local headers=$3
  local authtype=$4
  local data=$5
  local cookie=$6
  local tokencall=$7
  local insecure=""
  
  code=0
  resp=""
  respheaders=""

  [ -f "/tests/data/resp" ] && rm /tests/data/resp
  [[ $url == "https://"* ]] && insecure="--insecure"
  [[ $tokencall != "true" ]] && ((testCalls=testCalls+1))
  testCallInfo="$method $url headers:$headers"

  if [ -z "$authtype" ]
  then
    if [ -z "$data" ]
    then
      # echo "No auth and no data"
      set -x
      if [ -z "$cookie" ]
      then
        code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method "$url");
      else
        code=$(curl $insecure -i --cookie "$cookie" --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method "$url");
      fi
      set +x
    else
      # echo "No auth and has data"
      set -x
      if [ -z "$cookie" ]
      then
        code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method -d "$data" "$url");
      else
        code=$(curl $insecure -i --cookie "$cookie" --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method -d "$data" "$url");
      fi
      set +x
    fi
  else
    if [[ $authtype == "Bearer" ]]
    then
      if [ -z "$data" ]
      then
        # echo "Bearer auth and no data"
        set -x
        if [ -z "$cookie" ]
        then
          code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Bearer $jwt" -X $method "$url");
        else
          code=$(curl $insecure -i --cookie "$cookie" --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Bearer $jwt" -X $method "$url");
        fi
        set +x
      else
        if [ -z "$cookie" ]
        then
          code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Bearer $jwt" -X $method -d "$data" "$url");
        else
          code=$(curl $insecure -i --cookie "$cookie" --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Bearer $jwt" -X $method -d "$data" "$url");
        fi
        # echo "Bearer auth and has data"
      fi
    else
      if [ -z "$data" ]
      then
        # echo "Basic auth and no data"
        set -x  
        if [ -z "$cookie" ]
        then
          code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Basic $credential" -X $method "$url");
        else
          code=$(curl $insecure -i --cookie "$cookie" --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -H "Authorization: Basic $credential" -X $method "$url");
        fi
        set +x  
      else
        # echo "Basic auth and has data"   
        set -x  
        if [ -z "$cookie" ]
        then
          code=$(curl $insecure -i --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method -d "$data" "$url");
        else
          code=$(curl $insecure -i --cookie "$cookie" --write-out '%{http_code}' --silent --output /tests/data/resp -H Accept:application/json -H Content-Type:application/json $headers -X $method -d "$data" "$url");
        fi
        set +x  
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
  set -x
  resp=$(cat /tests/data/resp_body);
  respheaders=$(cat /tests/data/resp_headers);
  set +x
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
  http_call "POST" "$tokenServiceUrl" "" "" "$body" "" "true"
  set -x
  if [ "$code" == "200" ];
  then
    jwt=$(echo $resp| jq -r '.access_token')
  fi
  set +x
  # echo "jwt=$jwt"
}

function authenticate() {
  local body=""
  local headers=""
  [[ ! -z "$1" ]] && body=$(cat $1)
  [[ ! -z "$2" ]] && body=$2
  [[ ! -z "$3" ]] && headers=$3
  
  set -x
  if [[ ! -z $body ]] && [[ ! -z $headers ]];
  then
    jwt=""
    http_call "POST" "$tokenServiceUrl" "$headers" "" "$body" "" "true"
    if [ "$code" == "200" ];
    then
      jwt=$(echo $resp| jq -r '.access_token')
    fi
  else
    echo "Error on authenticate: missing credential or required headers" >> /tests/logs/error.log
  fi 
  set +x
}

function check_test_call() {
  {{/* if [[ -z "$1" ]]
  then
    echo "Missing test name - test will be skipped" >> /tests/logs/error.log
    ((skippedTestChecks=skippedTestChecks+1))
  else */}}
    local expectcode="200"
    local expectop="eq"
    {{/* testname=$1 */}}
    test_result="succeed"
    [[ ! -z "$1" ]] && expectcode=$1
    [[ ! -z "$2" ]] && expectop=$2
    ((testChecks=testChecks+1))
    if [[ $expectop == "eq" ]]
    then
      if [[ $code -eq $expectcode ]]
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
      if [[ $code -ne $expectcode ]]
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
    echo "Test call[$testCallInfo] result[$test_result]" >> /tests/logs/report.txt   

  {{/* fi */}}
}

function test_check() {
  set -x
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
      ((failedTestChecks=failedTestChecks+1))
      test_result="failed"
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
        if [[ $lookupresult == "$expectvalue"* ]] 
        then
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ $expectop == "suffix" ]]
      then
        if [[ $lookupresult == *"$expectvalue" ]] 
        then
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ $expectop == "regex" ]]
      then
        if [[ "$lookupresult" =~ $expectvalue ]] 
        then
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ $expectop == "pr" ]]
      then
        if [[ $lookupresult != "null" ]] 
        then
          ((succeedTestChecks=succeedTestChecks+1))
        else
          ((failedTestChecks=failedTestChecks+1))
          test_result="failed"
        fi
      elif [[ $expectop == "npr" ]]
      then
        if [[ $lookupresult == "null" ]] 
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
    echo "Test check on[$expectedQueryPath] result[$test_result] [$lookupresult $expectop $expectvalue]" >> /tests/logs/report.txt
  fi
  set +x
}

{{- end -}}

