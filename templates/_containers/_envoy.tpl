{{- define "titan-mesh-helm-lib-chart.containers.envoy.containerName" -}}
  {{- print "titan-envoy" -}}
{{- end }}

{{- define "titan-mesh-helm-lib-chart.containers.envoy" -}}
  {{- $titanSideCars := .titanSideCars -}}
  {{- $namespace := .namespace -}}
  {{- if $titanSideCars -}}
    {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
    {{- $envoy := $titanSideCars.envoy -}}
    {{- $useDynamicConfiguration := $envoy.useDynamicConfiguration | default false }}
    {{- $useSeparateConfigMaps := $envoy.useSeparateConfigMaps | default false }}
    {{- $loadDynamicConfigurationFromGcs := $envoy.loadDynamicConfigurationFromGcs }}
    {{- $loadDynamicConfigurationFromGcsEnabled := ternary $loadDynamicConfigurationFromGcs.enabled false (hasKey $loadDynamicConfigurationFromGcs "enabled") }}
    {{- $envoyConfigFolder := $envoy.configFolder | default "/envoy/config" -}}
    {{- $envoyConfigFileFolder := $envoy.configFileFolder | default $envoyConfigFolder -}}
    {{- $ratelimitConfigPath := $envoy.ratelimitConfigPath | default "/configs/ratelimit/config" -}}
    {{- $envoyConfigVolumeMountPath := $envoy.configVolumeMountPath | default "/data" -}}
    {{- $envoyScriptsFolder := $envoy.scriptsFolder | default "/envoy" -}}
    {{- $envars := $envoy.env -}}
    {{- $clusters := $envoy.clusters }}
    {{- $remoteMyApp := index $clusters "remote-myapp" -}}
    {{- $localMyApp := index $clusters "local-myapp" -}}
    {{- $ingress := $titanSideCars.ingress }}
    {{- $ingressroutes := list -}}
    {{- if $ingress.routes -}}
      {{- $ingressroutes = $ingress.routes -}}
    {{- else if $localMyApp.routes -}}
      {{- $ingressroutes = $localMyApp.routes -}}
    {{- end -}}
    {{- $wasmFilterUsed := eq (include "titan-mesh-helm-lib-chart.envoy.filter.enrichment.enabled" (dict "requests" $ingress "routes" $ingressroutes)) "true" -}}
    {{- if not $wasmFilterUsed -}}
      {{- $wasmFilterUsed = eq (include "titan-mesh-helm-lib-chart.envoy.filter.custom.response.enabled" (dict "requests" $ingress "routes" $ingressroutes)) "true" -}}
    {{- end -}}
    {{- $envoyIngressPort := coalesce $remoteMyApp.targetPort $remoteMyApp.port "9443" }}
    {{- $envoyHealthChecks := $remoteMyApp.healthChecks }}
    {{- $envoyHealthChecksStartup := $envoyHealthChecks.startup }}
    {{- $envoyHealthChecksStartupEnabled := ternary $envoyHealthChecksStartup.enabled true  (hasKey $envoyHealthChecksStartup "enabled") }}
    {{- $envoyHealthChecksCmdsStartup := $envoyHealthChecksStartup.commands }}
    {{- $envoyHealthChecksLiveness := $envoyHealthChecks.liveness }}
    {{- $envoyHealthChecksLivenessEnabled := ternary $envoyHealthChecksLiveness.enabled true  (hasKey $envoyHealthChecksLiveness "enabled") }}
    {{- $envoyHealthChecksCmdsLiveness := $envoyHealthChecksLiveness.commands }}
    {{- $envoyHealthChecksReadiness := $envoyHealthChecks.readiness }}
    {{- $envoyHealthChecksReadinessEnabled := ternary $envoyHealthChecksReadiness.enabled true  (hasKey $envoyHealthChecksReadiness "enabled") }}
    {{- $envoyHealthChecksCmdsReadiness := $envoyHealthChecksReadiness.commands }}
    {{- $envoyHealthChecksPath := $envoyHealthChecks.path | default "/healthz" -}}
    {{- $envoyHealthChecksScheme:= $envoyHealthChecks.scheme | default "HTTPS" -}}
    {{- $logs := $titanSideCars.logs -}}
    {{- $logType := $logs.type | default "stream" -}}
    {{- $envoyCPU := $envoy.cpu -}}
    {{- $envoyMemory := $envoy.memory -}}
    {{- $envoyStorage := $envoy.ephemeralStorage -}}
    {{- $imageRegistry := $envoy.imageRegistry | default $titanSideCars.imageRegistry -}}
    {{- $imageRegistry = ternary "" (printf "%s/" $imageRegistry) (eq $imageRegistry "") -}}
    {{- if $envoyEnabled }}
- name: {{include "titan-mesh-helm-lib-chart.containers.envoy.containerName" . }}
  image: {{ printf "%s%s:%s" $imageRegistry  ($envoy.imageName | default "envoy") ($envoy.imageTag | default "latest") }}
  imagePullPolicy: IfNotPresent
  env:
    - name: KUBERNETES_NAMESPACE
      value: {{ $namespace | quote }}
      {{- range $k, $v := $envars }}
    - name: {{ $k | upper }}
      value: {{ $v | quote }}
      {{- end }}  
  command: 
    - /usr/local/bin/envoy 
    - -c
    - {{ printf "%s/envoy.yaml" (trimSuffix "/" $envoyConfigFileFolder) }}
    - --service-cluster
    - {{ .appName }}
    - --service-node
    - ${HOSTNAME}
    - -l
    - {{ $logs.level | default "warning" }}
      {{- if eq $logType "file" }}
    - --log-path
    - "/logs/envoy.application.log"
      {{- else }}
    - --log-format
    - '%L%m%d %T.%e %t envoy] [%t][%n]%v'
      {{- end }}
  resources:
    limits:
      cpu: {{ $envoyCPU.limit | default "1" | quote }}
      memory: {{ $envoyMemory.limit | default "1Gi" | quote }}
      ephemeral-storage: {{ $envoyStorage.limit | default "500Mi" | quote }}
    requests:
      cpu: {{ $envoyCPU.request | default "250m" | quote }}
      memory: {{ $envoyMemory.request | default "256Mi" | quote }}
      ephemeral-storage: {{ $envoyStorage.request | default "100Mi" | quote }}
  lifecycle:
    preStop:
      exec:
        command:
          - sh
          - -c
          - wget --post-data="" -O - http://127.0.0.1:10000/healthcheck/fail && sleep {{ $envoy.connectionDrainDuration | default "80" }} || true
      {{- if $envoyHealthChecksStartupEnabled }}
  startupProbe:
        {{- if $envoyHealthChecksStartup.useCustomhealthCheckCmds }}
    exec:
      command:
        - {{ print ($envoyHealthChecksStartup.customHealthCheckCmdScript | default (printf "%s/health_check_restart_pod.sh" (trimSuffix "/" $envoyScriptsFolder))) | quote }} 
        - "startup"
        - {{ print ($envoy.startupFailureThreshold | default "300") | quote }}
          {{- if $wasmFilterUsed }}
        - "true"
          {{- end }}
        {{- else if $envoyHealthChecksCmdsStartup }}
    exec:
      command:
          {{- range $envoyHealthChecksCmdsStartup }}
        {{ printf "- %s" (. | quote) }}
          {{- end }}
        {{- else }}
    httpGet:
      path: {{ $envoyHealthChecksPath }}
      port: {{ $envoyIngressPort }}
      scheme: {{ $envoyHealthChecksScheme}}
        {{- end }}
    initialDelaySeconds: {{ $envoy.startupInitialDelaySeconds | default "5" }}
    failureThreshold: {{ $envoy.startupFailureThreshold | default "300" }}
    periodSeconds: {{ $envoy.startupPeriodSeconds | default "1" }}
    timeoutSeconds: {{ $envoy.startupTimeoutSeconds | default "5" }}
      {{- end }}
      {{- if $envoyHealthChecksLivenessEnabled }}
  livenessProbe:
        {{- if $envoyHealthChecksLiveness.useCustomhealthCheckCmds }}
    exec:
      command:
        - {{ print ($envoyHealthChecksLiveness.customHealthCheckCmdScript | default (printf "%s/health_check_restart_pod.sh" (trimSuffix "/" $envoyScriptsFolder))) | quote }} 
        - "liveness"
        - {{ print ($envoy.livenessFailureThreshold | default "2") | quote }}
          {{- if $wasmFilterUsed }}
        - "true"
          {{- end }}
        - "-m"
        - {{ $envoyConfigFolder }}
        - "-m"
        - {{ $ratelimitConfigPath }}
        {{- else if $envoyHealthChecksCmdsLiveness }}
    exec:
      command:
          {{- range $envoyHealthChecksCmdsLiveness }}
        {{ printf "- %s" (. | quote) }}
          {{- end }}
        {{- else }}
    httpGet:
      path: {{ $envoyHealthChecksPath }}
      port: {{ $envoyIngressPort }}
      scheme: {{ $envoyHealthChecksScheme}}
        {{- end }}
    initialDelaySeconds: {{ $envoy.livenessInitialDelaySeconds | default "1" }}
    failureThreshold: {{ $envoy.livenessFailureThreshold | default "2" }}
    periodSeconds: {{ $envoy.livenessPeriodSeconds | default "3" }}
    timeoutSeconds: {{ $envoy.livenessTimeoutSeconds | default "5" }}
      {{- end }}
      {{- if $envoyHealthChecksReadinessEnabled }}
  readinessProbe:
        {{- if $envoyHealthChecksReadiness.useCustomhealthCheckCmds }}
    exec:
      command:
        - {{ print ($envoyHealthChecksReadiness.customHealthCheckCmdScript | default (printf "%s/health_check_restart_pod.sh" (trimSuffix "/" $envoyScriptsFolder))) | quote }} 
        - "readiness"
        - {{ print ($envoy.readinessFailureThreshold | default "1") | quote }}
          {{- if $wasmFilterUsed }}
        - "true"
          {{- end }}
        {{- else if $envoyHealthChecksCmdsReadiness }}
    exec:
      command:
          {{- range $envoyHealthChecksCmdsReadiness }}
        {{ printf "- %s" (. | quote) }}
          {{- end }}
        {{- else }}
    httpGet:
      path: {{ $envoyHealthChecksPath }}
      port: {{ $envoyIngressPort }}
      scheme: {{ $envoyHealthChecksScheme}}
        {{- end }}
    initialDelaySeconds: {{ $envoy.readinessInitialDelaySeconds | default "1" }}
    failureThreshold:  {{ $envoy.readinessFailureThreshold | default "1" }}
    periodSeconds: {{ $envoy.readinessPeriodSeconds | default "3" }}
    timeoutSeconds: {{ $envoy.readinessTimeoutSeconds | default "5" }}
      {{- end }}
  volumeMounts:
      {{- if $useDynamicConfiguration }}
        {{- if $loadDynamicConfigurationFromGcsEnabled }}
    - mountPath: {{ $envoyConfigVolumeMountPath }}
      name: titan-configs-envoy-data
        {{- else }}
        {{- if $useSeparateConfigMaps }}
    - mountPath: {{ $envoyConfigFolder }}
      name: titan-configs-envoy-dmc
    - mountPath: {{ printf "%s/cds" (trimSuffix "/" $envoyConfigFolder) }}
      name: titan-configs-envoy-cds
    - mountPath: {{ printf "%s/lds" (trimSuffix "/" $envoyConfigFolder) }}
      name: titan-configs-envoy-lds
        {{- else }}
    - mountPath: {{ $envoyConfigFolder }}
      name: titan-configs-envoy-dmc
        {{- end }}
        {{- end }}
      {{- else }}
    - mountPath: {{ $envoyConfigFolder }}
      name: titan-configs
      {{- end }}
    - mountPath: /logs/
      name: {{ include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $titanSideCars }}
    - mountPath: /secrets
      name: titan-secrets-tls
      {{- if $envoy.intTlsCert }}  
    - mountPath: /secrets/int
      name: titan-secrets-tls-int
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}


