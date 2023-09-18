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

{{ template "validation_bash_core_functions" . }}

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
badTestChecks=0

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
