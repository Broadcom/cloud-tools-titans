{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $integration := $titanSideCars.integration }}
  {{- if $integration }}
    {{- $environment := $integration.environment }}
    {{- $tests := $integration.tests }}
    {{- if $environment }}
      {{- $ingress := $environment.ingress | default dict "address" "envoy-ingress:9443" }}
      {{- $logFolder := $environment.logFolder | default "./logs" }}

#!/bin/bash

{{ template "validation_bash_core_functions" . }}

mkdir -p {{ $logFolder }}

# setup single trap
trap 'trp' SIGUSR1
trap 'trp' SIGTERM
trp() {
  echo "[`date -Is`] receive signal to exit" >> "{{ $logFolder }}/envoy-ingress-health-check.log"
  exit 0
}

# health check
while :         
do
  healthCheck=$(curl --insecure --write-out '%{http_code}' --silent --output /dev/null -X GET {{ printf "%s" ($environment.proxyAddress | default "https://envoy-ingress:9443") | quote }}/healthz");
  if [ "$healthCheck" != "200" ];
  then
    echo "[`date -Is`] healthCheck: $healthCheck" >> "{{ $logFolder }}/envoy-ingress-health-check.log"
  else
    break
  fi
  sleep 1        
done


expectedFailedCalls=0
expectedfailedTestChecks=0

testCalls=0
succeedCalls=0
failedCalls=0
testChecks=0
failedTestChecks=0
succeedTestChecks=0
badTestChecks=0

        {{- range $tests }}
          {{- $name := .name }}
          {{- $request := .request }}
          {{- $result := .result }}
          {{- if $request }}
            {{- $host := $request.address | default $ingress.address }}
            {{- $token := $request.token }}
            {{- if $token }}
              {{- $privs := $token.privs | default "" }}
              {{- $scope := $token.scope | default "" }}            
              {{- $roles := $token.roles | default "" }}            
              {{- $uri := $token.uri | default "" }}
              {{- $cid := $token.customer_id | default "" }}
              {{- $did := $token.domain_id | default "" }}
              {{- $clid := $token.client_id | default "" }}
              {{- printf "get_token" }}
            {{- end }}
            {{- $headers := $request.headers }}
            {{- $hdrStr := "" }}
            {{- range $headers -}}
              {{- if eq  $hdrStr "" -}}
                {{- $hdrStr = printf "-H %s:%s" .name .value -}}
              {{- else -}}
                {{- $hdrStr = printf "%s %s:%s" $hdrStr .name .value -}}
              {{- end -}}
            {{- end -}}
            {{- $method := $request.method | default "GET" }}
            {{- $path := $request.path | default "/" }}
            {{- $url := printf "%s%s" $address $path }}
            {{- $bodyStr := ($request.body | toJson) | default "" }}
            {{- printf "http_call %s %s %s %s\n" ($method | quote) ($url | quote) ($hdrStr | squote) ("Bearer" | quote) ($bodyStr | squote) -}}
            {{- if $result }}
              {{- printf "unset validation_array && declare -A validation_array\n" }}
              {{- if $result.code }}
                {{- $code := $result.code }}
                {{- printf "validation_array[%s]=%s\n" ("code" | quote) (printf "%s:::%s" ($code.op | default "eq") $code.value | quote) }}
              {{- end }}
              {{- $body := $result.body }}
              {{- range $body }}
                {{- if and .path (or .value .op) }}
                {{- printf "validation_array[%s]=%s\n" (.path | quote) (printf "%s:::%s" (.op | default "eq") .value | quote) }}
              {{- end }}
              {{- printf "check_and_report\n" }}
              {{- printf "echo %s >> %s\n" (printf "Test case[%s] result[$test_result]: call %s %s%s" $name $method $scheme $path | quote) $reportfile }}
            {{- end }}
          {{- end }}
        {{- end }}
        {{- printf "echo \"Summary:\" >> \"%s/report.txt\"\n" $logFolder }}
        {{- printf "echo \"  Completed $testCalls test calls\" >> \"%s/report.txt\"\n" $logFolder }}
        {{- printf "echo \"    Succeed $succeedCalls test calls\" >> \"%s/report.txt\"\n" $logFolder }}
        {{- printf "echo \"    Failed $failedCalls test calls\" >> \"%s/report.txt\"\n" $logFolder }}
        {{- printf "echo \"  Completed $testChecks test checks\" >> \"%s/report.txt\"\n" $logFolder  }}
        {{- printf "echo \"    Succeed $succeedCalls test checks\" >> \"%s/report.txt\"\n" $logFolder }}
        {{- printf "echo \"    Failed $failedTestChecks test checks\" >> \"%s/report.txt\"\n" $logFolder }}
        {{- printf "echo \"    $badTestChecks test checks\" >> \"%s/report.txt\"\n" $logFolder }}
if [ "$failedCalls" == "$expectedFailedCalls" ] && [ "$failedTestChecks" == "$expectedfailedTestChecks" ]
then
  exit 0
else
  exit 1
fi
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
