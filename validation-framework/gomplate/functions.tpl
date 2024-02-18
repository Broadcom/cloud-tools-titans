{{- define "process_routing_enrichment" -}}
  {{- $enrichment := .enrichment }}
  {{- $path := .path | default "/" }}
  {{- $cluster := .cluster -}}
  {{- $scheme := .scheme -}}
  {{- $respfile := .respfile -}}
  {{- $direction := .direction -}}
  {{- $reportfile := .reportfile -}}
  {{- $method := "GET" }}
  {{- $authType := "" }}
  {{- $tokenCheck := false }}
  {{- if $enrichment -}}
    {{- if hasKey $enrichment "actions" }}
      {{- $actions := $enrichment.actions }}
      {{- range $actions }}
        {{- $match_headers := list }}
        {{- range .match_headers }}
          {{- $header := dict }}
          {{- $_ := set $header "key" .name }}
          {{- if eq .pattern "ex" }}
            {{- if .invert }}
              {{- $_ := set $header "npr" true }}
            {{- else }}
              {{- $_ := set $header "pr" true }}
            {{- end }}
          {{- else if eq .pattern "eq" }}
            {{- if .invert }}
              {{- $_ := set $header "neq" .value }}
            {{- else }}
              {{- $_ := set $header "eq" .value }}
            {{- end }}
          {{- else if eq .pattern "sw" }}
            {{- if .invert }}
              {{- $_ := set $header "nsw" .value }}
            {{- else }}
              {{- $_ := set $header "sw" .value }}
            {{- end }}
          {{- else if eq .pattern "ew" }}
            {{- if .invert }}
              {{- $_ := set $header "new" .value }}
            {{- else }}
              {{- $_ := set $header "ew" .value }}
            {{- end }}
          {{- else if eq .pattern "co" }}
            {{- if .invert }}
              {{- $_ := set $header "nco" .value }}
            {{- else }}
              {{- $_ := set $header "co" .value }}
            {{- end }}
          {{- else if eq .pattern "regex" }}
            {{- if .invert }}
              {{- $_ := set $header "nlk" .value }}
            {{- else }}
              {{- $_ := set $header "lk" .value }}
            {{- end }}
          {{- end }}
          {{- $match_headers = append $match_headers $header }}
        {{- end }}
        {{- $inout := dict "headers" dict "method" $method "path" $path "authType" $authType "tokenCheck" $tokenCheck }}
        {{- if gt (len $match_headers) 0 -}}
          {{- template "process_match_headers" (dict "match_headers" $match_headers "inout" $inout) }}
          {{- $path = $inout.path }}
          {{- $method = $inout.method }}
          {{- $authType = $inout.authType }}
          {{- $tokenCheck = $inout.tokenCheck }}
        {{- end }}
        {{- $headers := $inout.headers -}}
        {{/* {{- $hdrStr := "" }}
        {{- range $k, $v := $headers -}}
          {{- if eq  $hdrStr "" -}}
            {{- $hdrStr = printf "-H %s:%s" $k $v -}}
          {{- else -}}
            {{- $hdrStr = printf "%s -H %s:%s" $hdrStr $k $v -}}
          {{- end -}}
        {{- end -}} */}}
        {{- $act := dict }}
        {{- $_ := set $act "action" .action }}
        {{- $_ := set $act "to" .to }}
        {{- $_ := set $act "from" .from }}
        {{- if .transforms }}
          {{- $_ := set $act "transforms" .transforms }}
        {{- end }}
        {{- $acts := list $act }}
        {{- template "process_routing_enrichment_validation" (dict "method" "GET" "scheme" $scheme "path" "/" "headers" $headers "direction" $direction "cluster" $cluster "enrich" (dict "actions" $acts) "respfile" $respfile "reportfile" $reportfile) -}}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end -}}

{{- define "process_routing_enrichment_validation" -}}
  {{- $method := .method -}}  
  {{- $scheme := .scheme -}}
  {{- $path := .path }}
  {{- $headers := .headers }}
  {{- $cluster := .cluster -}}
  {{- $direction := .direction -}}
  {{- $enrich := .enrich }}
  {{- $respfile := .respfile -}}
  {{- $reportfile := .reportfile -}}
  {{- if $enrich }}
    {{- $calls := list }}
    {{- $actions := $enrich.actions }}
    {{- if $actions }}
      {{- $froms := dict }}
      {{- $tos := dict }}
      {{- range $actions }}
        {{- $_ := set $froms (printf "%s" .from) . }}
        {{- $to := printf "%s" .to }}
        {{- $toStr := printf "%s%s" (ternary "" "header." (contains "." $to)) $to }}
        {{- $_ := set $tos $toStr . }}
      {{- end }}
      {{- $checks := list }}
        {{- $inout := dict "skipping" dict }}
        {{- range (reverse $actions) }}
          {{- if eq .action "extract" }}
            {{- $skipping := $inout.skipping }}
            {{- if not (hasKey $skipping .from) }}
              {{- $_ := set $inout "skipping" $skipping }}
              {{- $_ := set $inout "inValue" "" }}
              {{- $_ := set $inout "outValue" (randAlpha 5) }}
              {{- $checks = list }}
              {{- template "process_action_recursive" (dict "tos" $tos "action" . "recursive" false "inout" $inout) }}
              {{- $checks = append $checks (dict "header" (printf "%s" $inout.to) "val" $inout.outValue) }}
              {{- $calls = append $calls (dict "from" (printf "%s" $inout.from) "val" $inout.inValue "checks" $checks) }}
            {{- end }}
          {{- end }}
      {{- end }}
    {{- end }}
    {{- $unsupportedCalls := dict "token.jti" true }}
    {{- range $calls }}
      {{- printf "#call=%s\n" . }}
      {{- printf "#call.from=%s .val=%s\n" .from .val }}
      {{- if not (hasKey $unsupportedCalls .from) }}
        {{- $callPath := $path }}
        {{- $authType := "" }}
        {{- $cookie := "" }}
        {{- $body := "" }}
        {{- if and (hasPrefix "header.Authorization" .from) (hasPrefix "Basic " .val) }}
          {{- $authType = "Basic" }}
          {{- printf "credential=%s\n" (trimPrefix "Basic " .val | quote) }}
        {{- else if hasPrefix "header.Cookie" .from  }}
          {{- $cookie = printf "%s" .val }}
        {{- else if hasPrefix "header." .from  }}
          {{- $_ := set $headers (trimPrefix "header." .from) .val }}
        {{- else if hasPrefix "token." .from }}
          {{- template "request_token" (dict "from" .from  "value" .val) -}}
          {{- $authType = "Bearer" }}
        {{- else if hasPrefix "query." .from }}
          {{- if contains "?" $callPath }}
            {{- $callPath = printf "%s&%s=%s" $callPath (trimPrefix "query." .from) .val }}
          {{- else }}
            {{- $callPath = printf "%s?%s=%s" $callPath (trimPrefix "query." .from) .val }}
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
        {{- printf "http_call %s %s %s %s %s %s\n" ($method | quote) (printf "%s%s" $scheme $callPath | quote) (printf "%s" $hdrStr | squote) ($authType | quote) ($body | quote) ($cookie | quote) -}}
        {{- printf "check_test_call\n" -}}
        {{- range .checks }}
          {{- template "build_execute_jq_cmd" (dict "path" (printf ".request.headers.%s" .header)) }}
          {{- printf "test_check %s\n" (.val | quote) }}
          {{- printf "echo %s >> %s\n" (printf "Test case[auto][enrich:advance:positive] result[$test_result]: call %s %s%s" $method $scheme $callPath | quote) $reportfile }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end -}}

{{- define "process_action_recursive" -}}
  {{- $tos := .tos -}}
  {{- $action := .action }}
  {{- $recursive := .recursive | default false }}
  {{- $inout := .inout -}}
  {{- if $action }}
    {{- $toStr := $inout.to | default "" }}
    {{- if eq $toStr "" }}
      {{- $toStr = $action.to }}
    {{- end }}
    {{- $to := get $tos $action.from | default dict }}
    {{- $outValue := ternary $inout.inValue $inout.outValue $recursive }}
    {{- $inValue := $inout.outValue }}
    {{- if $to }}
      {{- $args := dict "outValue" $outValue "inValue" $inValue }}
      {{- template "process_transforms" (dict "transforms" $action.transforms "args" $args "from" $action.from) }}
      {{- if $recursive }}
        {{- $skipping := $inout.skipping | default dict }}
        {{- $_ := set $skipping $action.from true }}
        {{- $_ := set $inout "skipping" $skipping }}
      {{- else }}
        {{- $_ := set $inout "from" $action.from }}
        {{- $_ := set $inout "to" $action.to }}
      {{- end }}
      {{- $_ := set $inout "inValue" $args.inValue }}
      {{- $_ := set $inout "outValue" $args.outValue }}
      {{- template "process_action_recursive" (dict "tos" $tos "action" $to "recursive" true "inout" $inout) }}
    {{- else }}
      {{- $args := dict "outValue" $outValue "inValue" $inValue }}
      {{- template "process_transforms" (dict "transforms" $action.transforms "args" $args "from" $action.from) }}
      {{- $_ := set $inout "from" $action.from }}
      {{- if $recursive }}
        {{- $skipping := $inout.skipping | default dict }}
        {{- $_ := set $skipping $action.from true }}
        {{- $_ := set $inout "skipping" $skipping }}
      {{- else }}
        {{- $_ := set $inout "to" $action.to }}
        {{- $_ := set $inout "outValue" $args.outValue }}
      {{- end }}
      {{- $_ := set $inout "inValue" $args.inValue }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "process_transforms" -}}
  {{- $transforms := .transforms -}}
  {{- $from := .from }}
  {{- $args := .args -}}
  {{- $outValue := $args.outValue }}
  {{- $inValue := $outValue }}
  {{- $marker := "xxxxxx" }}
  {{- if $transforms }}
    {{- range (reverse $transforms) }}
      {{- if eq .func "scanf" }}
        {{- $param := first .parameters }}
        {{- $param = $param | replace "%_" (ternary $marker (randAlpha 5) (hasPrefix "header.Cookie" $from)) }}
        {{- $inValue = $param | replace "%s" $inValue }}
      {{- else if eq .func "base64_decode" }}
        {{- $inValue = b64enc $inValue }}
      {{- else if eq .func "trim_prefix" }}
        {{- $inValue = printf "%s%s" (first .parameters) $inValue }}
      {{- else if eq .func "split" }}
        {{- $delimiter := index .parameters 0 }}
        {{- $op := index .parameters 1 }}
        {{- $pattern := index .parameters 2 }}
        {{- if hasPrefix "header.Cookie" $from }}
          {{- $inValue = $inValue | replace $marker $pattern }}
        {{- end }}
        {{- if eq $op "index" }}
          {{/* {{- $index := index .parameters 2 }}
          {{- range $i, $e := until $index }}
            {{- $inValue = printf "%s%s" (randAlpha 3) $op }}
          {{- end }} */}}
        {{- else }}
          {{- if eq $op "findFirstPrefix" }}
            {{- $inValue = printf "%s%s%s" (ternary (printf "%s=%s" (randAlpha 3) (randAlpha 3)) (randAlpha 3) (hasPrefix "header.Cookie" $from)) $delimiter (printf "%s" $inValue) }}
          {{- else if eq $op "findFirstContain" }}
            {{- $inValue = printf "%s%s%s" (ternary (printf "%s=%s" (randAlpha 3) (randAlpha 3)) (randAlpha 3) (hasPrefix "header.Cookie" $from)) $delimiter (printf "%s%s%s" (randAlpha 2) $inValue (randAlpha 2)) }}
          {{- else if eq $op "findFirst" }}
            {{- $inValue = printf "%s%s%s" (ternary (printf "%s=%s" (randAlpha 3) (randAlpha 3)) (randAlpha 3) (hasPrefix "header.Cookie" $from)) $delimiter $inValue }}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- $_ := set $args "inValue" $inValue }}
{{- end -}}


{{- define "request_token" -}}
  {{- $from := .from }}
  {{- $value := .value }}
  {{- $privs := "" }}
  {{- $scope := "" }}            
  {{- $roles := "" }}            
  {{- $cid := "" }}
  {{- $did := "" }}
  {{- $uri := "" }}
  {{- $clid := "" }}         
  {{- if hasPrefix "token." ($from | default "") }}            
    {{- $claim := trimPrefix "token." ($from | default "") }}
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
    {{- end }}
  {{- end }}
  {{- printf "get_token %s %s %s %s %s %s %s\n" ($privs | quote) ($scope | quote) ($roles | quote) ($cid | quote) ($did | quote) ($uri | quote) ($clid | quote) }}
{{- end -}}

{{- define "process_match_headers" -}}
  {{- $match_headers := .match_headers }}
  {{- $inout := .inout }}
  {{- $path := $inout.path }}
  {{- $method := $inout.method }}
  {{- $authType := $inout.authType }}
  {{- $tokenCheck := $inout.tokenCheck }}
  {{- $headers := dict }}
  {{- range $match_headers -}}
    {{- $key := .key -}}
    {{- $val := "" -}}
    {{- $pre := ternary "/" "" (eq $key ":path") }}
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
      {{- $val = printf "%s%s%s" $pre (randAlpha 5) .ew -}}             
    {{- else if hasKey . "co" -}}
      {{- $val = printf "%s%s%s%s" $pre (randAlpha 5) .co (randAlpha 5) -}}              
    {{- else if hasKey . "lk" -}}
      {{- $val = randFromUrlRegex .lk }}
    {{- else if hasKey . "pr" -}}
      {{- if .pr -}}
        {{- $val = "test" -}}          
      {{- end }}
    {{- else if hasKey . "neq" -}}
      {{- $val = printf "%s%s" .neq (randAlpha 5) -}}          
    {{- else if hasKey . "nsw" -}}
      {{- $val = printf "%s%s%s" $pre (randAlpha 5) .nsw -}}          
    {{- else if hasKey . "new" -}}
      {{- $val = printf "%s%s" .new (randAlpha 5) -}} 
    {{- else if hasKey . "nco" -}}
      {{- $val = printf "%s%s" $pre (randAlpha 5) -}} 
    {{- else if hasKey . "nlk" -}}
      {{- $val = printf "%s%s" $pre (randAlpha 5) -}} 
    {{- end -}}
    {{- if ne $val "" -}}
      {{- if eq $key ":path" -}}
        {{- $path = $val -}}
      {{- else if eq $key ":method" -}}
        {{- if .eq }}
          {{- $method = upper .eq -}}
        {{- else if .neq -}}
          {{- $neq := upper .neq -}}
          {{- if eq "GET" $neq -}}
            {{- $method = "DELETE" -}}
          {{- else if eq "POST" $neq -}}
            {{- $method = "PUT" -}}
          {{- else if eq "PUT" $neq -}}
            {{- $method = "POST" -}}
          {{- else if eq "DELETE" $neq -}}
            {{- $method = "PATCH" -}}
          {{- else if eq "PATCH" $neq -}}
            {{- $method = "DELETE" -}}
          {{- end -}}
        {{- end }}
      {{- else if eq $key ":authority" -}}
        {{- $_ := set $headers "Host" $val -}}
      {{- else -}}
        {{- $_ := set $headers $key $val -}}
      {{- end -}}
    {{- end -}}
  {{- end }}
  {{- $_ := set $inout "headers" $headers }}
  {{- $_ := set $inout "method" $method }}
  {{- $_ := set $inout "path" $path }}
  {{- $_ := set $inout "authType" $authType }}
  {{- $_ := set $inout "tokenCheck" $tokenCheck }}
{{- end }}


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
        {{- template "validate_routing_curl_jq_cmds" (dict "routing" $routing "cluster" $cluster "clusters" $clusters "scheme" $scheme "direction" $direction "respfile" $respfile "reportfile" $reportfile "tokenCheck" $tokenCheck) -}}
      {{- else if $routing.route -}}
        {{- $route := $routing.route -}}
        {{- if and $route.cluster $clusters -}}
          {{- $clusteValue := index $clusters $route.cluster -}}
          {{- if $clusteValue }}
            {{- range $clusteValue.routes }}
              {{- template "validate_routing_curl_jq_cmds" (dict "routing" . "cluster" $cluster "clusters" $clusters "scheme" $scheme "direction" $direction "respfile" $respfile "reportfile" $reportfile "tokenCheck" $tokenCheck) -}}
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
  {{- $direction := .direction }}
  {{- $tokenCheck := .tokenCheck | default false }}
  {{- $path := "" -}}
  {{- $cmd := "" -}}
  {{- $method := "GET" -}}
  {{- $matchAllRoutes := false }}
  {{- if hasKey $routing "match" -}}
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
      {{- $path = randFromUrlRegex $match.regex }}
    {{- end -}}
    {{- $inout := dict "headers" dict "method" $method "path" $path "authType" $authType "tokenCheck" $tokenCheck }}
    {{- if hasKey $match "headers" -}}
      {{- printf "# before process_match_headers=%s\n"  $inout }}
      {{- template "process_match_headers" (dict "match_headers" $match.headers "inout" $inout) }}
      {{- $method = $inout.method }}
      {{- $path = $inout.path }}
      {{- $authType = $inout.authType }}
      {{- $tokenCheck = $inout.tokenCheck }}
      {{- printf "# after process_match_headers=%s\n"  $inout }}
    {{- end }}
    {{- $headers := $inout.headers -}}
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
          {{- printf "http_call %s %s %s %s %s\n" ($method | quote) (printf "%s%s" $scheme (ternary "/validate_any_route" $rbacPath $matchAllRoutes) | quote) (printf "%s" $rbacHdrStr | squote) (printf "%s" "Bearer" | quote) ($bodyStr | quote) -}}
          {{- printf "check_test_call\n" -}}
          {{- printf "echo %s >> %s\n" (printf "Test case[auto][rbac:%s:positive] result[$test_result]: call %s %s%s" $name $method $scheme $rbacPath | quote) $reportfile }}
          {{- $usePreviousTokenCall = true }}
          {{- $callMade = true }}
        {{- end }}
      {{- end }}
      {{- if $enrich }}
        {{- template "process_routing_enrichment_validation" (dict "method" $method "scheme" $scheme "path" $path "enrich" $enrich "headers" $headers "cluster" $cluster "direction" $direction "respfile" $respfile "reportfile" $reportfile) -}}
      {{- end }}
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
        {{- else if hasKey $route "regexRewrite" }}
          {{- $regexRewrite := $route.regexRewrite }}
          {{- $regexSubstitution := $regexRewrite.substitution }}
          {{- $subStrs := split "\\" $regexSubstitution }}
          {{- $newPath := $regexSubstitution }}
          {{- $count := 1 }}
          {{- range $subStrs }}
            {{- if lt $count (len $subStrs) }}
              {{- $newPath = $newPath | replace (printf "\\%d" $count) "[^/]+" }}
              {{- $count = add1 $count }}
            {{- end }}
          {{- end }}
          {{- template "build_execute_jq_cmd" (dict "path" ".http.originalUrl") }}
          {{- printf "test_check %s %s\n" ($newPath | quote) ("regex" | quote) }}
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
  {{- end -}}
{{- end -}}
