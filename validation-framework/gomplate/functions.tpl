{{- define "process_routing_validation" -}}
  {{- $routing := .routing -}}
  {{- $clusters := .clusters -}}
  {{- $cluster := .cluster -}}
  {{- $respfile := .respfile -}}
  {{- $direction := .direction -}}
  {{- $reportfile := .reportfile -}}
  {{- $tokenCheck := .tokenCheck | default false }}
  {{- if $routing -}}
    {{- $scheme := .scheme -}}
    {{- $rtest := false -}}
    {{- if eq $direction "ingress" -}}
      {{- if or (hasKey $routing "route") (hasKey $routing "rbac")  (hasKey $routing "enrich") -}}
        {{- $rtest = true -}}
      {{- end -}}
    {{- else -}}
      {{- $rtest = true -}}
    {{- end -}}
    {{- if $rtest -}}
      {{- if $routing.match -}}
        {{- template "validate_routing_curl_jq_cmds" (dict "routing" $routing "cluster" $cluster "clusters" $clusters "scheme" $scheme "respfile" $respfile "reportfile" $reportfile "tokenCheck" $tokenCheck) -}}
      {{- else if $routing.route -}}
        {{- $route := $routing.route -}}
        {{- if and $route.cluster $clusters -}}
          {{- $clusteValue := index $clusters $route.cluster -}}
          {{- if $clusteValue }}
            {{- range $clusteValue.routes }}
              {{- template "validate_routing_curl_jq_cmds" (dict "routing" . "cluster" $cluster "clusters" $clusters "scheme" $scheme "respfile" $respfile "reportfile" $reportfile "tokenCheck" $tokenCheck) -}}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "prepare_jq_path_without_backslash" -}}
  {{- $path = . }}
  {{- $parts := split "." $path }}
  {{- $jpath := "" }}
  {{- range $parts }}
    {{- if ne . "" }}
      {{- if hasSuffix "[]" . }}
        {{- $jpath = printf "%s.%s" $jpath (printf "%s[]" (trimSuffix "[]" . | quote)) }}
      {{- else }}
        {{- $jpath = printf "%s.%s" $jpath (printf "%s" . | quote) }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- $jpath -}}
{{- end }}

{{- define "prepare_jq_path" -}}
  {{- $path = . }}
  {{- $parts := split "." $path }}
  {{- $jpath := "" }}
  {{- range $parts }}
    {{- if ne . "" }}
      {{- $jpath = printf "%s.%s" $jpath (printf "\\\"%s\\\"" .) }}
    {{- end }}
  {{- end }}
  {{- $jpath -}}
{{- end }}

{{- define "build_execute_jq_cmd" -}}
  {{- $resp := ternary "$respheaders" "$resp" (hasKey . "from") }}
  {{- if .jq }}
    {{- printf "expectedQueryPath=%s\n" (.jq | squote) }}
    {{- printf "set -x\n" }}
    {{- printf "lookupresult=$(echo %s | jq -r '%s')\n" $resp .jq }}   
    {{- printf "set +x\n" }} 
  {{- else }}
    {{- $path := .path }}
    {{- $select := .select }}
    {{- $op := .op | default "eq" }}
    {{- $value := .value | default "" }}
    {{- if $select }}
      {{- $skey := $select.key | default "" }}
      {{- $svalue := $select.value | default "" }}
      {{- if or (eq $skey "") (eq $svalue "")}}
        {{- printf "Unsupported usage: Both key and value are require when using select command %v for path=%s\n >>/tests/logs/error.log\n" $select $path }}
      {{- else }}
        {{- $itms := split "[]" $path }}
        {{- $jpath := "" }}
        {{- $parts := split "." $itms._0 }}
        {{- range $parts }}
          {{- if ne . "" }}
            {{- $jpath = printf "%s.%s" $jpath (printf "%s" . | quote) }}
          {{- end }}
        {{- end }}
      {{- $parts := split "." $skey }}
      {{- $kpath := "" }}
        {{- range $parts}}
          {{- if ne . "" }}
            {{- $kpath = printf "%s.%s" $kpath (printf "%s" . | quote) }}
          {{- end }}
        {{- end }}
        {{- $parts = split "." $itms._1 }}
        {{- $jobj := "" }}
        {{- range $parts }}
          {{- if ne . "" }}
            {{- $jobj = printf "%s.%s" $jobj (printf "%s" . | quote) }}
          {{- end }}
        {{- end }}
        {{- printf "expectedQueryPath='%s[] | select(%s==%s) | %s'\n" $jpath $kpath ($svalue | quote) $jobj }}
        {{- printf "set -x\n" }}
        {{- printf "lookupresult=$(echo %s | jq -r '%s[] | select(%s==%s) | %s')\n" $resp $jpath $kpath ($svalue | quote) $jobj }}  
        {{- printf "set +x\n" }}  
      {{- end }}
    {{- else }}
      {{- if hasSuffix "[]" $path }}
        {{- if and (eq $op "has") (ne $value "") }}
          {{- $parts := split "." $path }}
          {{- $jpath := "" }}
          {{- range $parts }}
            {{- if ne . "" }}
              {{- if hasSuffix "[]" . }}
                {{- $jpath = printf "%s.%s" $jpath (printf "%s[]" (trimSuffix "[]" . | quote)) }}
              {{- else }}
                {{- $jpath = printf "%s.%s" $jpath (printf "%s" . | quote) }}
              {{- end }}
            {{- end }}
          {{- end }}
          {{- printf "expectedQueryPath='%s | select(.==%s) | .'\n" $jpath ($value | quote) }}
          {{- printf "set -x\n" }}
          {{- printf "lookupresult=$(echo %s | jq -r '%s | select(.==%s) | .')\n"  $resp $jpath ($value | quote)}}
          {{- printf "set +x\n" }}
        {{- else }}
          {{- printf "Unsupported usage: only \"has\" oprator(%s) is supported on the path(%s)[] with value(%s)\n >>/tests/logs/error.log\n" $op $path $value }}
        {{- end }}
      {{- else if contains "[]" $path }}
        {{- $parts := split "[]" $path }}
        {{- $preStr := "" }}
        {{- range (split "." $parts._0) }}
          {{- if ne . "" }}
            {{ $preStr = printf "%s.%s" $preStr (printf "\\\"%s\\\"" .) }}
          {{- end }}
        {{- end }}
        {{- if eq $preStr "" }}
          {{- $preStr = "." }}
        {{- end }}
        {{- $suffixStr := "" }}
        {{- range  (split "." $parts._1) }}
          {{- if ne . "" }}
            {{ $suffixStr = printf "%s.%s" $suffixStr (printf "\\\"%s\\\"" .) }}
          {{- end }}
        {{- end }}
        {{- printf "expectedQueryPath=%s\n" (printf "%s[]%s" $preStr $suffixStr) }} 
        {{- printf "set -x\n" }}
        {{- printf "lookupresult=$(echo %s | jq -r %s)\n"  $resp  (printf "%s[]%s" $preStr $suffixStr) }}
        {{- printf "set +x\n" }}
      {{- else }}
        {{- $parts := split "." $path }}
        {{- $jpath := "" }}
        {{- range $parts }}
          {{- if ne . "" }}
            {{- $jpath = printf "%s.%s" $jpath (printf "\\\"%s\\\"" .) }}
          {{- end }}
        {{- end }}
        {{- printf "expectedQueryPath=%s\n" $jpath }} 
        {{- printf "set -x\n" }}
        {{- printf "lookupresult=$(echo %s | jq -r %s)\n"  $resp  $jpath }}
        {{- printf "set +x\n" }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}


{{- define "validate_routing_curl_jq_cmds" -}}
  {{- $routing := .routing -}}
  {{- $respfile := .respfile -}}
  {{- $reportfile := .reportfile -}}
  {{- $cluster := .cluster -}}
  {{- $scheme := .scheme -}}
  {{- $tokenCheck := .tokenCheck | default false }}
  {{- $path := "" -}}
  {{- $cmd := "" -}}
  {{- $method := "GET" -}}
  {{- $headers := dict -}}
  {{- $matchAllRoutes := false }}
  {{- if hasKey $routing "match" -}}
    {{- $supported := true }}
    {{- $tokenCheck = ternary $routing.tokenCheck $tokenCheck (hasKey $routing "tokenCheck") }}
    {{- $authType := "Bearer" }}
    {{- $rbac := $routing.rbac }}
    {{- $enrich := $routing.enrich }}
    {{- $match := $routing.match -}}
    {{- if hasKey $match "method" -}}
      {{- $method = $match.method -}}
    {{- end -}}
    {{- if hasKey $match "prefix" -}}
      {{- $path = printf "%s/abc" (trimSuffix "/" $match.prefix) -}}
      {{- if and (eq $match.prefix "/") (not (hasKey $match "headers")) }}
        {{- $matchAllRoutes = true }}
      {{- end }}
    {{- else if hasKey $match "path" -}}
      {{- $path = printf "%s" $match.path -}}
    {{- else if hasKey $match "regex" -}}
      {{- $path = randFromRegex $match.regex }}
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
            {{- $val = printf "%s%s" .sw (randAlpha 5) -}}          
          {{- else if hasKey . "ew" -}}
            {{- $val = printf "/%s%s" (randAlpha 5) .ew -}}             
          {{- else if hasKey . "co" -}}
            {{- $val = printf "/%s%s%s" (randAlpha 5) .co (randAlpha 5) -}}              
          {{- else if hasKey . "lk" -}}
            {{- $val = randFromRegex .lk }}
          {{- else if hasKey . "pr" -}}
            {{- if .pr -}}
              {{- $val = "def" -}}          
            {{- end }}
          {{- else if hasKey . "neq" -}}
            {{- $val = printf "%s%s" .neq (randAlpha 5) -}}          
          {{- else if hasKey . "nsw" -}}
            {{- $val = printf "/%s%s" (randAlpha 5) .nsw -}}          
          {{- else if hasKey . "new" -}}
            {{- $val = printf "%s%s" .new (randAlpha 5) -}} 
          {{- else if hasKey . "nco" -}}
            {{- $val = printf "/%s" (randAlpha 5) -}} 
          {{- else if hasKey . "nlk" -}}
            {{- $val = printf "/%s" (randAlpha 5) -}} 
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
            {{- else if eq $key ":authority" -}}
              {{- $_ := set $headers "Host" $val -}}
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
          {{- $hdrStr = printf "%s -H %s:%s" $hdrStr $k $v -}}
        {{- end -}}
      {{- end -}}
      {{- $usePreviousTokenCall := false }}
      {{- $callMade := false }}
      {{- if or $rbac $enrich }}
        {{- $policies := $rbac.policies }}
        {{- range $policies }}
          {{- $rbacHdrStr := $hdrStr }}
          {{- $rbacPath := $path }}
          {{- $name := .name }}
          {{- $privs := "" }}
          {{- $scope := "" }}            
          {{- $roles := "" }}            
          {{- $cid := "" }}
          {{- $did := "" }}
          {{- $uri := "" }}
          {{- $clid := "" }}
          {{- $rules := .rules }}
          {{- $bodyJson := dict }} 
          {{- $bodyStr := "" }}   
          {{- $requestToken := false }}
          {{- range $rules }}
            {{- $lop := .lop | default "" }}
            {{- $rop := .rop | default "" }}
            {{- $val := .val | default "" }}
            {{- $inv := .inv | default false }}
            {{- $hasVal := false }}
            {{- if .val }}
              {{- $hasVal = true }}
            {{- end }}
            {{- if or (hasPrefix "request.token" $lop) (hasPrefix "request.token" $rop) }}
              {{- $hdrOprand := ternary $lop (ternary $rop "" (hasPrefix "request.headers" $rop)) (hasPrefix "request.headers" $lop) }}
              {{- $hdrName := ternary (trimPrefix "request.headers[" $hdrOprand | trimSuffix "]") "" (ne $hdrOprand "") }}
              {{- $queryOprand := ternary $lop (ternary $rop "" (hasPrefix "request.query" $rop)) (hasPrefix "request.query" $lop) }}
              {{- $queryParam := ternary (trimPrefix "request.query[" $queryOprand | trimSuffix "]") "" (ne $queryOprand "") }}
              {{- $bodyOprand := ternary $lop (ternary $rop "" (hasPrefix "request.body" $rop)) (hasPrefix "request.body" $lop) }}
              {{- $bodyAttrib := ternary (trimPrefix "request.body[" $bodyOprand | trimSuffix "]") "" (ne $bodyOprand "")  }}
              {{- if not $hasVal }}
                {{- if ne $hdrName "" }}
                  {{- $val = ternary (get $headers $hdrName) (randAlpha 5) (hasKey $headers $hdrName) }}
                  {{- if eq $rbacHdrStr "" -}}
                    {{- $rbacHdrStr = printf "-H %s:%s" $hdrName $val -}}
                  {{- else -}}
                    {{- $rbacHdrStr = printf "%s -H %s:%s"  $rbacHdrStr $hdrName $val -}}
                  {{- end -}}
                {{- else if ne $queryParam "" }}
                  {{- $val = randAlpha 5 }}
                  {{- if contains "?" $rbacPath }}
                    {{- $rbacPath = "printf %s&%s=%s" $rbacPath $queryParam $val }}
                  {{- else }}
                    {{- $rbacPath = "printf %s?%s=%s" $rbacPath $queryParam $val }}
                  {{- end }}
                {{- else if ne $bodyAttrib "" }}
                  {{- $val = randAlpha 5 }}
                  {{- $_ := set $bodyJson $bodyAttrib $val }}
                {{- end }}
              {{- end }}
              {{- if $inv }}
                {{- $val = randAlpha 5 }}
              {{- end }}
              {{- $tokenOprand := ternary $lop $rop (hasPrefix "request.token" $lop) }}
              {{- $claim := trimPrefix "request.token[" $tokenOprand | trimSuffix "]" }}
              {{- if eq $claim "scope" }}
                {{- if eq .op "co" }}
                  {{- $scope = ternary $val (printf "%s %s" $privs $val) (eq $scope "")  }}
                  {{- $requestToken = true }}
                {{- end }}
              {{- else if eq $claim "privs" }}
                {{- if eq .op "co" }}
                  {{- $privs = ternary $val (printf "%s %s" $privs $val) (eq $privs "") }}
                  {{- $requestToken = true }}
                {{- end }}
              {{- else if eq $claim "roles" }}
                {{- if eq .op "co" }}
                  {{- $roles = ternary $val (printf "%s<%s>" $roles $val) (eq $roles "") }}
                  {{- $requestToken = true }}
                {{- end }}
              {{- else if eq $claim "customer_id" }}
                {{- if eq .op "eq" }}
                  {{- $cid = $val }}
                  {{- $requestToken = true }}
                {{- else if eq .op "ne" }}
                  {{- $cid = randAlpha 8 }}
                  {{- $requestToken = true }}
                {{- end }}
              {{- else if eq $claim "domain_id" }}
                {{- if eq .op "eq" }}
                  {{- $did = $val }}
                  {{- $requestToken = true }}
                {{- else if eq .op "ne" }}
                  {{- $did = randAlpha 8 }}
                  {{- $requestToken = true }}
                {{- end }}
              {{- else if eq $claim "uri" }}
                {{- if eq .op "eq" }}
                  {{- $uri = $val }}
                  {{- $requestToken = true }}
                {{- else if eq .op "prefix" }}
                  {{- $uri = printf "%s%s" $val (randAlpha 3) }}
                  {{- $requestToken = true }}
                {{- end }}
              {{- else if eq $claim "client_id" }}
                {{- if eq .op "eq" }}
                  {{- $did = $val }}
                  {{- $requestToken = true }}
                {{- else if eq .op "ne" }}
                  {{- $requestToken = true }}
                {{- end }}
              {{- end }}
            {{- end }}
          {{- end }}
          {{- if $requestToken }}
            {{- if $bodyJson }}
              {{- $bodyStr = $bodyJson | toJson }}
            {{- end }}
            {{- printf "get_token %s %s %s %s %s %s %s\n" ($privs | quote) ($scope | quote) ($roles | quote) ($cid | quote) ($did | quote) ($uri | quote) ($clid | quote) }}
            {{- printf "http_call %s %s %s %s %s\n" ($method | quote) (printf "%s%s" $scheme (ternary "/validate_any_route" $rbacPath $matchAllRoutes) | quote) (printf "%s" $rbacHdrStr | squote) (printf "%s" "Bearer" | quote) ($bodyStr | quote) -}}
            {{- printf "check_test_call\n" -}}
            {{- printf "echo %s >> %s\n" (printf "Test case[auto][rbac:%s:positive] result[$test_result]: call %s %s%s" $name $method $scheme $rbacPath | quote) $reportfile }}
            {{- $usePreviousTokenCall = true }}
            {{- $callMade = true }}
          {{- end }}
        {{- end }}
        {{/* {{- $actions := $enrich.actions }}
        {{- range $actions }}
          {{- $action := .action }}
          {{- if eq $action "extract" }}
            {{- $privs := "" }}
            {{- $scope := "" }}            
            {{- $roles := "" }}            
            {{- $cid := "" }}
            {{- $did := "" }}
            {{- $uri := "" }}
            {{- $clid := "" }}         
            {{- $value := "" }}
            {{- $requestToken := false }}
            {{- if ne (.if_contain | default "") "" }}
              {{- $value = .if_contain }}
            {{- else if ne (.if_start_with | default "") "" }}
              {{- $value = printf "%sabc" .if_start_with }}
            {{- else if ne (.if_eq | default "") "" }}
              {{- $value = printf "%s" .if_eq }}
            {{- else }}
              {{- $value = "some_value" }}
            {{- end }}
            {{- if hasPrefix "token." (.from | default "") }}            
              {{- $claim := trimPrefix "token." (.from | default "") }}
              {{- if ne $value "" }}
                {{- if eq $claim "scope" }}
                  {{- $scope = $value }}
                {{- else if eq $claim "privs" }}
                  {{- $privs = $value }}
                {{- else if eq $claim "roles" }}
                  {{- $roles = $value }}
                {{- else if eq $claim "customer_id" }}
                  {{- $cid = $value }}
                {{- else if eq $claim "domain_id" }}
                  {{- $did = $value }}
                {{- else if eq $claim "uri" }}
                  {{- $uri = $value }}
                {{- else if eq $claim "client_id" }}
                  {{- $clid = $value }}
                {{- end }}
                {{- $requestToken = true }}
              {{- end }}
            {{- else if and .to (or (hasPrefix "header." (.from | default "")) (hasPrefix "query." (.from | default ""))) }}
              {{- $from := ternary (trimPrefix "header." .from) (trimPrefix "query." .from) (hasPrefix "header." (.from | default "")) }}                
              {{- if .transforms }}
                {{- range (reverse .transforms) }}
                  
                {{- end }}
              {{- end }}
              {{- if hasPrefix "header." (.from | default "") }}
                {{- if eq  $hdrStr "" -}}
                  {{- $hdrStr = printf "-H %s:%s" $from $value -}}
                {{- else -}}
                  {{- $hdrStr = printf "%s -H %s:%s" $hdrStr $from $value -}}
                {{- end -}}
              {{- else }}
                {{- if contains "?" $path }}
                  {{- $path = "printf %s&%s=%s" $path $from $value }}
                {{- else }}
                  {{- $path = "printf %s?%s=%s" $path $from $value }}
                {{- end }}
              {{- end }}
            {{- end }}
            {{- $authType := "" }}
            {{- if $requestToken }}
              {{- printf "get_token %s %s %s %s %s %s %s\n" ($privs | quote) ($scope | quote) ($roles | quote) ($cid | quote) ($did | quote) ($uri | quote) ($clid | quote) }}
              {{- $authType = "Bearer" }}
              {{- $usePreviousTokenCall = true }}
            {{- end }}
            {{- printf "http_call %s %s %s %s\n" ($method | quote) (printf "%s%s" $scheme (ternary "/validate_any_route" $path $matchAllRoutes) | quote) (printf "%s" $hdrStr | squote) ($authType | quote) -}}
            {{- printf "check_test_call\n" -}}
            {{- template "build_execute_jq_cmd" (dict "path" (printf ".request.headers.%s" .to)) }}
            {{- printf "test_check %s %s\n" ((ternary .with "" (hasKey . "with")) | quote) ((ternary "eq" "pr" (hasKey . "with")) | quote) }}
            {{- printf "echo %s >> %s\n" (printf "Test case[auto][enrich:positive] result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
            {{- $callMade = true }}
          {{- end }}
        {{- end }} */}}
      {{- else }}
        {{- printf "http_call %s %s %s %s\n" ($method | quote) (printf "%s%s" $scheme $path | quote) (printf "%s" $hdrStr | squote) (ternary (printf "%s" "Bearer" | quote) (printf "" | quote) $tokenCheck) -}}
        {{- $callMade = true }}
      {{- end }}
      {{- if $callMade }}
        {{- if hasKey $routing "redirect" -}}
          {{- $redirect := $routing.redirect -}}
          {{- printf "check_test_call %s\n" (($redirect.responseCode | default "301") | quote) }}
          {{- printf "echo %s >> %s\n" (printf "Test case[auto][redirect] result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
        {{- else if hasKey $routing "directResponse" -}}
          {{- $directResponse := $routing.directResponse -}}
          {{- printf "check_test_call %s\n" ($directResponse.status | quote) }}
          {{- printf "echo %s >> %s\n" (printf "Test case[auto][directResponse] result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
        {{- else if hasKey $routing "route" -}}
          {{- $route := $routing.route -}}
          {{- if not $usePreviousTokenCall }}
            {{- printf "check_test_call\n" }}
          {{- end }}
          {{- if hasKey $route "prefixRewrite" -}}
            {{- template "build_execute_jq_cmd" (dict "path" ".http.originalUrl") }}
            {{- printf "test_check %s %s\n" ($route.prefixRewrite | quote) ("prefix" | quote) }}
          {{- end -}}
            {{- template "build_execute_jq_cmd" (dict "path" ".host.hostname") }}
            {{- printf "test_check %s\n" ($cluster | quote) }}
          {{- printf "echo %s >> %s\n" (printf "Test case[auto][routing - path rewrite]result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
        {{- else -}}
          {{- printf "check_test_call\n" }}
          {{- if ne $cluster "proxy" }}
            {{- template "build_execute_jq_cmd" (dict "path" ".host.hostname") }}
            {{- printf "test_check %s\n" ($cluster | quote) }}
          {{- end }}
          {{- printf "echo %s >> %s\n" (printf "Test case[auto][routing] result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
        {{- end -}}
      {{- end }}
    {{- end }}
  {{- end -}}
{{- end -}}
