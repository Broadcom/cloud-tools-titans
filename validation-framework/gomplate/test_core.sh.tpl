{{- define "test_cases_core_framework" }}
  {{- $environment := .environment -}}
  {{- $remote := .remote | default false }}
  {{- $tests := .tests -}}
  {{- if and $environment $tests }}
    {{- $ingress := $environment.ingress | default (dict "address" "envoy-ingress:9443") }}
    {{- $logFolder := $environment.logFolder | default "./logs" }}

{{ template "validation_bash_core_functions" }}

    {{- if $remote }}
      {{- if hasKey $environment "tokenService" }}
        {{- $tokenService := $environment.tokenService }}
        {{- $url := $tokenService.url | default "https://token-generator:9443/tokens" }}
        {{- printf "\n\n" }}
        {{- printf "tokenServiceUrl=%s\n" ($url | quote) }}
      {{- end }}
    {{- end }}

mkdir -p {{ $logFolder }}

# setup single trap
trap 'trp' SIGUSR1
trap 'trp' SIGTERM
trp() {
  echo "[`date -Is`] receive signal to exit" >> "{{ $logFolder }}/envoy-ingress-health-check.log"
  exit 0
}

expectedFailedCalls=0
expectedfailedTestChecks=0

testCalls=0
succeedCalls=0
failedCalls=0
testChecks=0
failedTestChecks=0
succeedTestChecks=0
skippedTestChecks=0
badTestChecks=0
    {{- printf "\n" }}
    {{- range $tests }}
      {{- $name := .name }}
      {{- $request := .request }}
      {{- $result := .result }}
      {{- if $request }}
        {{- $address := $request.address | default $ingress.address }}
        {{- $token := $request.token }}
        {{- $tokenUrl := $request.tokenUrl }}
        {{- $credential := $request.credential }}
        {{- $authType := "" }}
        {{- if $tokenUrl }}
          {{- printf "\n" }}
          {{- printf "tokenServiceUrl=%s\n" ($tokenUrl | quote) }}        
        {{- end }}
        {{- if $token }}
          {{- $privs := $token.privs | default "" }}
          {{- $scope := $token.scope | default "" }}            
          {{- $roles := $token.roles | default "" }}            
          {{- $cid := $token.customer_id | default "" }}
          {{- $did := $token.domain_id | default "" }}
          {{- $uri := $token.uri | default "" }}
          {{- $clid := $token.client_id | default "" }}
          {{- printf "get_token %s %s %s %s %s %s %s\n" ($privs | quote) ($scope | quote) ($roles | quote) ($cid | quote) ($did | quote) ($uri | quote) ($clid | quote) }}
          {{- $authType = "Bearer" }}
        {{- else if $credential }}
          {{- $req := $credential.request }}
          {{- if $req }}
            {{- $headers := $req.headers }}
            {{- $hdrStr := "" }}
            {{- range $headers -}}
              {{- if eq  $hdrStr "" -}}
                {{- $hdrStr = printf "-H %s:%s" .name .value -}}
              {{- else -}}
                {{- $hdrStr = printf "%s -H %s:%s" $hdrStr .name .value -}}
              {{- end -}}
            {{- end -}}
            {{- $body := $req.body }}
            {{- if $body }}
              {{- if hasKey $body "data" }}
                {{- printf "authenticate %s %s %s\n" ("" | quote) (($body.data | toJson) | squote) ($hdrStr | squote) }}
                {{- $authType = "Bearer" }}
              {{- else if hasKey $body "file" }}
                {{- printf "authenticate %s %s %s\n" ($body.file | quote) ("" | quote) ($hdrStr | squote) }}
                {{- $authType = "Bearer" }}
              {{- end }}
            {{- end }}
          {{- end }}
        {{- end }}
        {{- $headers := $request.headers }}
        {{- $hdrStr := "" }}
        {{- range $headers -}}
          {{- if eq  $hdrStr "" -}}
            {{- $hdrStr = printf "-H %s:%s" .name .value -}}
          {{- else -}}
            {{- $hdrStr = printf "%s -H %s:%s" $hdrStr .name .value -}}
          {{- end -}}
        {{- end -}}
        {{- $method := $request.method | default "GET" }}
        {{- $path := $request.path | default "/" }}
        {{- $url := printf "%s%s" $address $path }}
        {{- $bodyStr := ternary ($request.body | toJson) "" (hasKey $request "body") }}
        {{- printf "http_call %s %s %s %s %s\n" ($method | quote) ($url | quote) ($hdrStr | squote) ($authType | quote) ($bodyStr | squote) }}
        {{- if $result }}
          {{- if $result.code }}
            {{- $code := $result.code }}
            {{- $op := $code.op | default "eq" }}
            {{- $value := $code.value | default "" }}
            {{- if and (eq $op "in") (hasKey $code "values") }}
              {{- $value = "" }}
              {{- range $code.values }}
                {{- if eq $value "" }}
                  {{- $value = printf "%s" . }}
                {{- else }}
                  {{- $value = printf "%s,%s" $value . }}
                {{- end }}
              {{- end }}
              {{- if not (contains "," $value) }}
                {{- $op = "eq" }}
              {{- end }}
            {{- end }}
            {{- printf "check_test_call %s %s\n" ($value | quote) ($op | quote) }}
          {{- end }}
          {{- $headers := $result.headers }}
          {{- range $headers }}
            {{- $op := .op | default "eq" }}
            {{- template "build_execute_jq_cmd" (dict "path" (printf ".%s" .name) "from" "headers" "jq" .jq) }}
            {{- printf "test_check %s %s\n" (.value | default "" | quote) ($op | quote) }}
          {{- end }}
          {{- $body := $result.body }}
          {{- range $body }}
            {{- $op := .op | default "eq" }}
            {{- template "build_execute_jq_cmd" (dict "path" .path "select" .select "op" $op "value" .value "jq" .jq) }}
            {{- printf "test_check %s %s\n" (.value | default "" | quote) ((ternary "eq" $op (and (eq $op "has") (hasSuffix "[]" .path))) | quote) }}
          {{- end }}
          {{- printf "echo %s >> %s\n" (printf "Test case[%s] result[$test_result]: call %s" $name $url | quote) (printf "%s/report.txt" $logFolder | quote) }}
        {{- end }}
      {{- end }}
    {{- end }}
    {{- printf "echo %s >> %s\n" ("Summary:" | quote) (printf "%s/report.txt" $logFolder | quote) }}
    {{- printf "echo %s >> %s\n" ("  Completed $testCalls test calls" | quote) (printf "%s/report.txt" $logFolder | quote) }}
    {{- printf "echo %s >> %s\n" ("    Succeed $succeedCalls test calls" | quote) (printf "%s/report.txt" $logFolder | quote) }}
    {{- printf "echo %s >> %s\n" ("    Failed $failedCalls test calls" | quote) (printf "%s/report.txt" $logFolder | quote) }}
    {{- printf "echo %s >> %s\n" ("  Completed $testChecks tests" | quote) (printf "%s/report.txt" $logFolder | quote) }}
    {{- printf "echo %s >> %s\n" ("    Succeed $succeedTestChecks test checks" | quote) (printf "%s/report.txt" $logFolder | quote) }}
    {{- printf "echo %s >> %s\n" ("    Failed $failedTestChecks test checks" | quote) (printf "%s/report.txt" $logFolder | quote) }}
    {{- printf "echo %s >> %s\n" ("    Skipped $skippedTestChecks test checks" | quote) (printf "%s/report.txt" $logFolder | quote) }}
    {{- printf "echo %s >> %s\n" ("    $badTestChecks bad tests" | quote) (printf "%s/report.txt" $logFolder | quote) }}
if [ "$failedCalls" == "$expectedFailedCalls" ] && [ "$failedTestChecks" == "$expectedfailedTestChecks" ]
then
  exit 0
else
  exit 1
fi
  {{- end }}
{{- end }}
