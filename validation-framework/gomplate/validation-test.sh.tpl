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

mkdir -p /tests/logs
exec 2> /tests/logs/auto-test-trace.log

{{ template "validation_bash_core_functions" }}

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
skippedTestChecks=0
badTestChecks=0

echo "" > /tests/logs/report.txt
echo "[`date`]### Execute auto-generated tests ###" > /tests/logs/report.txt
echo "" >> /tests/logs/report.txt

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
  {{- printf "echo %s >> %s\n" ("Summary:" | quote) ("/tests/logs/report.txt" | quote) }}
  {{- printf "echo %s >> %s\n" ("  Completed $testCalls test calls" | quote) ("/tests/logs/report.txt" | quote) }}
  {{- printf "echo %s >> %s\n" ("    Succeed $succeedCalls test calls" | quote) ("/tests/logs/report.txt" | quote) }}
  {{- printf "echo %s >> %s\n" ("    Failed $failedCalls test calls" | quote) ("/tests/logs/report.txt" | quote) }}
  {{- printf "echo %s >> %s\n" ("  Completed $testChecks tests" | quote) ("/tests/logs/report.txt" | quote) }}
  {{- printf "echo %s >> %s\n" ("    Succeed $succeedTestChecks test checks" | quote) ("/tests/logs/report.txt" | quote) }}
  {{- printf "echo %s >> %s\n" ("    Failed $failedTestChecks test checks" | quote) ("/tests/logs/report.txt" | quote) }}
  {{- printf "echo %s >> %s\n" ("    $badTestChecks bad tests" | quote) ("/tests/logs/report.txt" | quote) }}
  {{- printf "echo %s >> %s\n" ("    Skipped $skippedTestChecks test checks" | quote) ("/tests/logs/report.txt" | quote) }}

  if [ "$failedCalls" == "$expectedFailedCalls" ] && [ "$failedTestChecks" == "$expectedfailedTestChecks" ]
  then
    exit 0
  else
    exit 1
  fi
{{- end }}
