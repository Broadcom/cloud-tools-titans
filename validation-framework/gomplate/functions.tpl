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
      {{- if hasKey $routing "redirect" -}}
        {{- $redirect := $routing.redirect -}}
        {{- printf "unset validation_array && declare -A validation_array\n" }}
        {{- printf "validation_array[%s]=%s\n" (printf "%s" "code" | quote) (printf "eq:::%s" ($redirect.responseCode | default "301") | quote) }}
        {{- printf "check_and_report\n" }}
        {{- printf "echo %s >> %s\n" (printf "Test case[redirect] result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
      {{- else if hasKey $routing "directResponse" -}}
        {{- $directResponse := $routing.directResponse -}}
        {{- printf "unset validation_array && declare -A validation_array\n" }}
        {{- printf "validation_array[%s]=%s\n" (printf "%s" "code" | quote) (printf "eq:::%s" $directResponse.status | quote) }}
        {{- printf "check_and_report\n" }}
        {{- printf "echo %s >> %s\n" (printf "Test case[directResponse] result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
      {{- else if hasKey $routing "route" -}}
        {{- $route := $routing.route -}}
        {{- printf "unset validation_array && declare -A validation_array\n" }}
        {{- printf "validation_array[%s]=%s\n" (printf "%s" "code" | quote) (printf "eq:::%s" "200" | quote) }}
        {{- if hasKey $route "prefixRewrite" -}}
          {{- printf "validation_array[%s]=%s\n" (printf "%s" ".http.originalUrl" | quote) (printf "prefix:::%s" $route.prefixRewrite | quote) }}
        {{- end -}}
        {{- printf "validation_array[%s]=%s\n" (printf "%s" ".host.hostname" | quote) (printf "eq:::%s" $cluster | quote) }}
        {{- printf "check_and_report\n" }}
        {{- printf "echo %s >> %s\n" (printf "Test case[routing - path rewrite]result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
      {{- else -}}
        {{- printf "unset validation_array && declare -A validation_array\n" }}
        {{- printf "validation_array[%s]=%s\n" (printf "%s" "code" | quote) (printf "eq:::%s" "200" | quote) }}
        {{- printf "check_and_report\n" }}
        {{- printf "echo %s >> %s\n" (printf "Test case[routing] result[$test_result]: call %s %s%s" $method $scheme $path | quote) $reportfile }}
      {{- end -}}
    {{- end }}
  {{- end -}}
{{- end -}}
