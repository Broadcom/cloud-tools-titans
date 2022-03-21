{{- define "titan-mesh-helm-lib-chart-legacy.containers.envoy.containerName" -}}
{{- print "titan-envoy" -}}
{{- end }}

{{- define "titan-mesh-helm-lib-chart-legacy.containers.envoy" -}}
{{- $titanSideCars := .titanSideCars -}}
{{- if $titanSideCars }}
  {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
  {{- $envoy := $titanSideCars.envoy -}}
  {{- $clusters := $envoy.clusters }}
  {{- $remoteMyApp := index $clusters "remote-myapp" }}
  {{- $envoyIngressPort := coalesce $remoteMyApp.targetPort $remoteMyApp.port "9443" }}
  {{- $envoyHealthChecks := $remoteMyApp.healhChecks }}
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
- name: {{include "titan-mesh-helm-lib-chart-legacy.containers.envoy.containerName" . }}
  image: {{ printf "%s%s:%s" $imageRegistry  ($envoy.imageName | default "envoy") ($envoy.imageTag | default "latest") }}
  imagePullPolicy: IfNotPresent
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
          - wget --post-data="" -O - http://127.0.0.1:10000/healthcheck/fail || true
  livenessProbe:
    httpGet:
      path: {{ $envoyHealthChecksPath }}
      port: {{ $envoyIngressPort }}
      scheme: {{ $envoyHealthChecksScheme}}
    initialDelaySeconds: 5
    failureThreshold: {{ $envoy.livenessFailureThreshold | default "50" }}
    periodSeconds: 10
  readinessProbe:
    httpGet:
      path: {{ $envoyHealthChecksPath }}
      port: {{ $envoyIngressPort }}
      scheme: {{ $envoyHealthChecksScheme}}
    initialDelaySeconds: 1
    failureThreshold:  {{ $envoy.readinessFailureThreshold | default "100" }}
    periodSeconds: 5
  volumeMounts:
    - mountPath: /envoy/envoy.yaml
      name: titan-configs
      subPath: envoy.yaml
    - mountPath: /envoy/envoy-sds.yaml
      name: titan-configs
      subPath: envoy-sds.yaml
    - mountPath: /logs/
      name: {{ include "titan-mesh-helm-lib-chart-legacy.volumes.logsVolumeName" $titanSideCars }}
    - mountPath: /secrets
      name: titan-secrets-tls
  {{- end }}
{{- end }}
{{- end }}


