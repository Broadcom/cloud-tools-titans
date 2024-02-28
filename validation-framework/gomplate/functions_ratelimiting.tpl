{{- define "process_routing_ratelimiting_validation" -}}
  {{- $routing := .routing -}}
  {{- $clusters := .clusters -}}
  {{- $cluster := .cluster -}}
  {{- $respfile := .respfile -}}
  {{- $direction := .direction -}}
  {{- $reportfile := .reportfile -}}
  {{- $tokenCheck := .tokenCheck | default false }}
  {{- if $routing -}}
    {{- $scheme := .scheme -}}
    {{- if ne $direction "egress" -}}
      {{- if and (hasKey $routing "match") (hasKey $routing "ratelimit") -}}
        {{- template "validate_routing_ratelimiting_curl_jq_cmds" (dict "routing" $routing "cluster" $cluster "clusters" $clusters "scheme" $scheme "direction" $direction "respfile" $respfile "reportfile" $reportfile "tokenCheck" $tokenCheck) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "validate_routing_ratelimiting_curl_jq_cmds" -}}
  {{- $routing := .routing }}
  {{- $respfile := .respfile }}
  {{- $reportfile := .reportfile }}
  {{- $cluster := .cluster }}
  {{- $scheme := .scheme }}
  {{- $direction := .direction }}
  {{- $tokenCheck := .tokenCheck | default false }}
  {{- $path := "" }}
  {{- $pathDup := "" }}
  {{- $cmd := "" }}
  {{- $method := "GET" }}
  {{- $matchAllRoutes := false }}
  {{- if hasKey $routing "match" }}
    {{- $tokenCheck = ternary $routing.tokenCheck $tokenCheck (hasKey $routing "tokenCheck") }}
    {{- $authType := "Bearer" }}
    {{- $rbac := $routing.rbac }}
    {{- $match := $routing.match }}
    {{- $ratelimit := $routing.ratelimit }}

    {{- if hasKey $match "method" -}}
      {{- $method = $match.method -}}
    {{- end -}}
    {{- if hasKey $match "prefix" -}}
      {{- $path = printf "%s/abc" (trimSuffix "/" $match.prefix) -}}
      {{- $pathDup = printf "%s/abc" (trimSuffix "/" $match.prefix) -}}
      {{- if and (eq $match.prefix "/") (not (hasKey $match "headers")) }}
        {{- $matchAllRoutes = true }}
      {{- end }}
    {{- else if hasKey $match "path" -}}
      {{- $path = printf "%s" $match.path -}}
      {{- $pathDup = printf "%s" $match.path -}}
    {{- else if hasKey $match "regex" -}}
      {{- $path = randFromUrlRegex $match.regex }}
      {{- $pathDup = randFromUrlRegex $match.regex }}
    {{- end -}}

    {{- $inout := dict "headers" dict "method" $method "path" $path "authType" $authType "tokenCheck" $tokenCheck }}
    {{- $inoutDup := dict "headers" dict "method" $method "path" $path "authType" $authType "tokenCheck" $tokenCheck }}

    {{- if hasKey $match "headers" -}}
      {{- printf "# before process_match_headers, inout=%s\n"  $inout }}
      {{- template "process_match_headers" (dict "match_headers" $match.headers "inout" $inout) }}
      {{- $method = $inout.method }}
      {{- $path = $inout.path }}
      {{- $authType = $inout.authType }}
      {{- $tokenCheck = $inout.tokenCheck }}
      {{- printf "# after process_match_headers, inout=%s\n" $inout }}

      {{- printf "# get a duplicated path in case of no key specified for ratelimit\n" }}
      {{- printf "# before process_match_headers, inout=%s\n" $inoutDup }}
      {{- template "process_match_headers" (dict "match_headers" $match.headers "inout" $inoutDup) }}
      {{- $pathDup = $inoutDup.path }}
      {{- printf "# after process_match_headers, inout=%s\n" $inoutDup }}
    {{- end }}

    {{- if $ratelimit }}
      {{- if hasKey $ratelimit "actions" }}
        {{- $ratelimitActions := $ratelimit.actions }}
        {{- range $ratelimitActions }}
          {{- if .limit }}
            {{- range .match }}
              {{- $ratelimitMatch := . }}
              {{- $noKeySpecified := false }}
              {{- $repeatingTest := list 1 2 }}
              {{- range $repeatingTest }}
                {{- if $noKeySpecified }}
                  {{- $path = $pathDup }}
                {{- end }}

                {{- $inout_with_rl := dict "headers" $inout.headers dict "method" $method "path" $path "authType" $authType "tokenCheck" $tokenCheck "noKeySpecified" $noKeySpecified }}
                {{- printf "# current ratelimit match: %s\n" $ratelimitMatch }}
                {{- printf "# before process_ratelimiting_match_keys, inout_with_rl=%s\n"  $inout_with_rl }}
                {{- template "process_ratelimiting_match_keys" (dict "match_ratelimit" $ratelimitMatch "inout_with_rl" $inout_with_rl) }}
                {{- printf "# after process_ratelimiting_match_keys, inout_with_rl=%s\n" $inout_with_rl }}

                {{- $noKeySpecified = $inout_with_rl.noKeySpecified }}

                {{- $headers := $inout_with_rl.headers -}}
                {{- $hdrStr := "" }}
                {{- range $k, $v := $headers -}}
                  {{- if eq  $hdrStr "" -}}
                    {{- $hdrStr = printf "-H %s:%s" $k $v -}}
                  {{- else -}}
                    {{- $hdrStr = printf "%s -H %s:%s" $hdrStr $k $v -}}
                  {{- end -}}
                {{- end -}}

                {{- $usePreviousTokenCall := false }}
                {{- $rbacHdrStr := $hdrStr }}
                {{- if $rbac }}
                  {{- $policy := first $rbac.policies -}}
                  {{- if $policy }}
                    {{- $rbacPath := $path }}
                    {{- $name := $policy.name }}
                    {{- $privs := "" }}
                    {{- $scope := "" }}            
                    {{- $roles := "" }}            
                    {{- $cid := "" }}
                    {{- $did := "" }}
                    {{- $uri := "" }}
                    {{- $clid := "" }}
                    {{- $rules := $policy.rules }}
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
                              {{- $rbacPath = printf "%s&%s=%s" $rbacPath $queryParam $val }}
                            {{- else }}
                              {{- $rbacPath = printf "%s?%s=%s" $rbacPath $queryParam $val }}
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
                      {{- printf "get_token %s %s %s %s %s %s %s\n" ($privs | quote) ($scope | quote) ($roles | quote) ($cid | quote) ($did | quote) ($uri | quote) ($clid | quote) }}
                      {{- if $bodyJson }}
                        {{- $bodyStr = $bodyJson | toJson }}
                      {{- end }}
                      {{- $usePreviousTokenCall = true }}
                    {{- end }}
                  {{- end }}
                {{- end }}

                {{- printf "http_call %s %s %s %s\n" ($method | quote) (printf "%s%s" $scheme $path | quote) (printf "%s" $hdrStr | squote) (ternary (printf "%s" "Bearer" | quote) (printf "" | quote) $tokenCheck) -}}
                {{- printf "check_test_call\n" }}

                {{- printf "http_call %s %s %s %s\n" ($method | quote) (printf "%s%s" $scheme $path | quote) (printf "%s" $hdrStr | squote) (ternary (printf "%s" "Bearer" | quote) (printf "" | quote) $tokenCheck) -}}
                {{- printf "check_test_call 429\n" }}

                {{- if ne $cluster "proxy" }}
                  {{- template "build_execute_jq_cmd" (dict "path" ".host.hostname") }}
                  {{- printf "test_check %s\n" ($cluster | quote) }}
                {{- end }}
                {{- printf "echo %s >> %s\n" (printf "Test case[auto][ratelimit] result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
              {{- end }}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end -}}
{{- end -}}

{{- define "process_ratelimiting_match_keys" -}}
  {{- $match_ratelimit := .match_ratelimit }}
  {{- $inout_with_rl := .inout_with_rl }}
  {{- $headers := $inout_with_rl.headers }}

  {{- if $match_ratelimit -}}
    {{- $key := $match_ratelimit.key -}}
    {{- $val := "" -}}

    {{- if ne $key ":path" }}
      {{- if hasKey $match_ratelimit "eq" -}}
        {{- $val = $match_ratelimit.eq -}}
      {{- else if hasKey $match_ratelimit "sw" -}}
        {{- $val = printf "%s%s" $match_ratelimit.sw (randAlpha 5) -}}          
      {{- else if hasKey $match_ratelimit "ew" -}}
        {{- $val = printf "%s%s" (randAlpha 5) .ew -}}             
      {{- else if hasKey $match_ratelimit "co" -}}
        {{- $val = printf "%s%s%s" (randAlpha 5) .co (randAlpha 5) -}}              
      {{- else if hasKey $match_ratelimit "lk" -}}
        {{- $val = randFromUrlRegex $match_ratelimit.lk }} # reuse randFromUrlRegex because the result contains only valid alphabetic and numbers
      {{- else if hasKey $match_ratelimit "pr" -}}
        {{- if .pr -}}
          {{- $val = "ratelimit-test" -}}          
        {{- end }}
      {{- else if hasKey $match_ratelimit "neq" -}}
        {{- $val = printf "%s%s" $match_ratelimit.neq (randAlpha 5) -}}          
      {{- else if hasKey $match_ratelimit "nsw" -}}
        {{- $val = printf "%s%s" (randAlpha 5) .nsw -}}          
      {{- else if hasKey $match_ratelimit "new" -}}
        {{- $val = printf "%s%s" $match_ratelimit.new (randAlpha 5) -}} 
      {{- else if hasKey $match_ratelimit "nco" -}}
        {{- $val = printf "%s" (randAlpha 5) -}} 
      {{- else if hasKey $match_ratelimit "nlk" -}}
        {{- $val = printf "%s" (randAlpha 5) -}}
      {{- else }}
        {{- $val = printf "%s" (randAlpha 5) -}}
      {{- end -}}
    {{- end }}

    {{- if ne $val "" -}}
      {{- if $headers }}
        {{- $_ := set $headers $key $val -}}
      {{- else }}
        {{- $headers = dict $key $val }}
      {{- end }}
    {{- else }}
      {{- $_ := set $inout_with_rl "noKeySpecified" true }}
    {{- end -}}
  {{- end }}
  {{- $_ := set $inout_with_rl "headers" $headers }}
{{- end }}

