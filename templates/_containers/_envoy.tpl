{{- define "titan-mesh-helm-lib-chart.containers.envoy.containerName" -}}
{{- print "titan-envoy" -}}
{{- end }}

{{- define "titan-mesh-helm-lib-chart.containers.envoy" -}}
{{- $titanSideCars := .titanSideCars -}}
{{- $namespace := .namespace -}}
{{- if $titanSideCars -}}
  {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
  {{- $envoy := $titanSideCars.envoy -}}
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
  {{- $wasmFilterUsed := false -}}
  {{- range $ingressroutes -}}
    {{- if or .enrich .rbac -}}
      {{- $wasmFilterUsed = true -}}
    {{- end -}}
  {{- end -}}
  {{- if not $wasmFilterUsed -}}
    {{- $enrich := mergeOverwrite (deepCopy ($envoy.enrich | default dict)) ($ingress.enrich | default dict) -}}
    {{- $rbacPolicies := mergeOverwrite (deepCopy ($envoy.rbacs | default dict)) ($ingress.rbacs | default dict) -}} 
    {{- range $enrich.actions -}}
      {{- $wasmFilterUsed = true -}}
    {{- end -}}
    {{- range $rbacPolicies.actions -}}
      {{- $wasmFilterUsed = true -}}
    {{- end -}}
    {{- if and (and (hasKey $enrich ".enabled") (not $enrich.enabled)) (and (hasKey $rbacPolicies ".enabled") (not $rbacPolicies.enabled)) }}
        {{- $wasmFilterUsed = false -}}
    {{- end -}}
  {{- end -}}
  {{- if $titanSideCars.ingress -}}
    {{- if hasKey $titanSideCars.ingress "enrich" -}}
      {{- if and (hasKey $titanSideCars.ingress "enabled") (not $titanSideCars.ingress.enabled) }}
        {{- $wasmFilterUsed = false -}}
      {{- end -}}
    {{- end -}}
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
    - /envoy/envoy.yaml
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
        - {{ print ($envoyHealthChecksStartup.customhealthCheckCmdScript | default "/envoy/health_check_restart_pod.sh") | quote }} 
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
    {{- end }}
    {{- if $envoyHealthChecksLivenessEnabled }}
  livenessProbe:
      {{- if $envoyHealthChecksLiveness.useCustomhealthCheckCmds }}
    exec:
      command:
        - {{ print ($envoyHealthChecksLiveness.customhealthCheckCmdScript | default "/envoy/health_check_restart_pod.sh") | quote }} 
        - "liveness"
        - {{ print ($envoy.livenessFailureThreshold | default "2") | quote }}
        {{- if $wasmFilterUsed }}
        - "true"
        {{- end }}
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
    {{- end }}
    {{- if $envoyHealthChecksReadinessEnabled }}
  readinessProbe:
      {{- if $envoyHealthChecksReadiness.useCustomhealthCheckCmds }}
    exec:
      command:
        - {{ print ($envoyHealthChecksReadiness.customhealthCheckCmdScript | default "/envoy/health_check_restart_pod.sh") | quote }} 
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
  {{- end }}
  volumeMounts:
    - mountPath: /envoy/envoy.yaml
      name: titan-configs
      subPath: envoy.yaml
    - mountPath: /envoy/envoy-sds.yaml
      name: titan-configs
      subPath: envoy-sds.yaml
    - mountPath: /logs/
      name: {{ include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $titanSideCars }}
    - mountPath: /secrets
      name: titan-secrets-tls
  {{- end }}
{{- end }}
{{- end }}


