{{- $globalRateLimitEnabled := true }}

{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $globalRateLimit := $titanSideCars.ratelimit }}
  {{- if hasKey $globalRateLimit "enabled" }}
    {{- $globalRateLimitEnabled = $globalRateLimit.enabled }}
  {{- end }}
  {{- $envoy := $titanSideCars.envoy }}
  {{- $ingress := $titanSideCars.ingress }}
  {{- $egress := $titanSideCars.egress }}
  {{- $service := .service }}
  {{- $validation := $titanSideCars.validation }}
  {{- $_ := set $envoy "clusters" (mergeOverwrite (deepCopy $envoy.clusters) $validation.clusters) -}}
  {{- $clusters := $envoy.clusters }}
  {{- $localMyApp := index $clusters "local-myapp" }}
  {{- $gatewayEnabled := ternary ($localMyApp.enabled | default true) false (hasKey $localMyApp "gateway") }}
  {{- $counter := 0 -}}
  {{- if or $gatewayEnabled (hasKey $ingress "routes") (hasKey $egress "routes") }}
#!/bin/sh

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
      {{- printf "# Process ingress routes\n" }}
      {{/* {{- if hasKey $ingress "enrichment" }}
        {{- $ingressEnrichment := $ingress.enrichment }}
        {{- if hasKey $ingressEnrichment "actions" }}
          {{- printf "# Ingress -> enrichment on all ingress API calls - path: /any\n" }}
          {{- template "process_routing_enrichment" (dict "enrichment" $ingressEnrichment "cluster" "proxy" "direction" "ingress" "scheme" "https://proxy:9443" "respfile" "/tests/logs/resp.txt" "reportfile" "/tests/logs/report.txt") }}
          {{- $counter = add1 $counter -}}
        {{- end }}
      {{- end }} */}}
      {{- range $ingress.routes }}
        {{- $cluster := "proxy" }}
        {{- $route := .route }}
        {{- if $route }}
          {{- if $route.cluster }}
            {{- $cluster = $route.cluster }}
          {{- end }}
        {{- end }}
        {{- if or (eq $cluster "proxy") (and (ne $cluster "proxy") (hasKey $clusters $cluster)) }}
          {{- if eq $cluster "local-myapp" }}
            {{- $cluster = "proxy" }}
          {{- end }}
          {{- printf "# Ingress -> host:%s - path: %s\n" $cluster . }}
            {{- if $globalRateLimitEnabled }}
              {{- template "process_routing_ratelimiting_validation" (dict "routing" . "cluster" $cluster "clusters" $clusters "direction" "ingress" "scheme" "https://proxy:9443" "respfile" "/tests/logs/resp.txt" "reportfile" "/tests/logs/report.txt" "tokenCheck" (ternary $ingress.tokenCheck false (hasKey $ingress "tokenCheck"))) }}
            {{- else }}
              {{- template "process_routing_validation" (dict "routing" . "cluster" $cluster "clusters" $clusters "direction" "ingress" "scheme" "https://proxy:9443" "respfile" "/tests/logs/resp.txt" "reportfile" "/tests/logs/report.txt" "tokenCheck" (ternary $ingress.tokenCheck false (hasKey $ingress "tokenCheck"))) }}
            {{- end }}
          {{- $counter = add1 $counter -}}
        {{- end }}
      {{- end }}     
    {{- end }}

    {{- if and (hasKey $egress "routes") (not $globalRateLimitEnabled) }}
# Process egress routes
      {{/* {{- if hasKey  $egress "enrichment" }}
        {{- $egressEnrichment := $egress.enrichment }}
        {{- if hasKey $egressEnrichment "actions" }}
          {{- printf "# Egress -> enrichment on all egress API calls\n" }}
          {{- template "process_routing_enrichment" (dict "enrichment" $egressEnrichment "cluster" "proxy" "direction" "egress" "scheme" "https://proxy:9443" "respfile" "/tests/logs/resp.txt" "reportfile" "/tests/logs/report.txt") }}
          {{- $counter = add1 $counter -}}
        {{- end }}
      {{- end }} */}}
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

    {{- if $gatewayEnabled }}
    # Process gateway routings
      {{- range $cluster, $clusterValue := $clusters }}
        {{- if and (ne $cluster "remote-myapp") (not (hasPrefix "local-" $cluster)) }}
          {{- $routes := $clusterValue.routes }}
          {{- range $routes }}
            {{- printf "# Gateway routing -> host:%s - routing: %s\n" $cluster . }}
            # disable ratelimit validation for gateway, may consider to open this up in the future as needed
            {{/* {{- if $globalRateLimitEnabled }}
                   {{- template "process_routing_ratelimiting_validation" (dict "routing" . "cluster" $cluster "clusters" $clusters "direction" "gateway" "scheme" "https://proxy:9443" "respfile" "/tests/logs/resp.txt" "reportfile" "/tests/logs/report.txt") }}
                 {{- else }}
                   {{- template "process_routing_validation" (dict "routing" . "cluster" $cluster "clusters" $clusters "direction" "gateway" "scheme" "https://proxy:9443" "respfile" "/tests/logs/resp.txt" "reportfile" "/tests/logs/report.txt") }}
                 {{- end }} */}}
            {{- template "process_routing_validation" (dict "routing" . "cluster" $cluster "clusters" $clusters "direction" "gateway" "scheme" "https://proxy:9443" "respfile" "/tests/logs/resp.txt" "reportfile" "/tests/logs/report.txt") }}
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
{{- end }}
