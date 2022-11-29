{{- define "titan-mesh-helm-lib-chart.containers.opa.containerName" -}}
{{- print "titan-opa" -}}
{{- end }}
{{- define "titan-mesh-helm-lib-chart.containers.opa" -}}
{{- $titanSideCars := . -}}
{{- if $titanSideCars }}
  {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
  {{- $opaEnabled := eq (include "static.titan-mesh-helm-lib-chart.opaEnabled" $titanSideCars) "true" -}}
  {{- $opa := $titanSideCars.opa -}}
  {{- $opaMonitorByEnvoy := $opa.monitorByEnvoy -}}
  {{- $opaCPU := $opa.cpu -}}
  {{- $opaMemory := $opa.memory -}}
  {{- $opaStorage := $opa.ephemeralStorage -}}
  {{- $imageRegistry := $opa.imageRegistry | default $titanSideCars.imageRegistry -}}
  {{- $imageRegistry = ternary "" (printf "%s/" $imageRegistry) (eq $imageRegistry "") -}}
  {{- if and $envoyEnabled $opaEnabled}}
- name: {{include "titan-mesh-helm-lib-chart.containers.opa.containerName" . }}
  image: {{ printf "%s%s:%s" $imageRegistry  ($opa.imageName | default "opa") ($opa.imageTag | default "latest") }}
  imagePullPolicy: IfNotPresent
  args:
    - "run"
    - "--server"
    - "--config-file=/etc/opa.yaml"
    - "--addr=localhost:8181"
    - "--diagnostic-addr=0.0.0.0:8282"
    - "--ignore=.*"
    - "/opa/policies"
    {{- if not $opaMonitorByEnvoy }}
  startupProbe:
    httpGet:
      path: {{ $opa.healthCheckPath | default "/health?plugins" }}
      port: {{ $opa.healthCheckPort | default "8282" }}
      scheme: {{ $opa.healthCheckScheme | default "HTTP" }}
    initialDelaySeconds: 5
    failureThreshold: {{ $opa.startupFailureThreshold | default "5" }}
    periodSeconds: 15
  livenessProbe:
    httpGet:
      path: {{ $opa.healthCheckPath | default "/health?plugins" }}
      port: {{ $opa.healthCheckPort | default "8282" }}
      scheme: {{ $opa.healthCheckScheme | default "HTTP" }}
    initialDelaySeconds: 1
    failureThreshold: {{ $opa.livenessFailureThreshold | default "1" }}
    periodSeconds: 15
  readinessProbe:
    httpGet:
      path: {{ $opa.healthCheckPath | default "/health?plugins" }}
      scheme: {{ $opa.healthCheckScheme | default "HTTP" }}
      port: {{ $opa.healthCheckPort | default "8282" }}
    initialDelaySeconds: 1
    failureThreshold: {{ $opa.readinessFailureThreshold | default "1" }}
    periodSeconds: 5
    {{- end }}
  lifecycle:
    preStop:
      exec:
        command:
          - sleep
          - {{ $opa.preStopDuration | default "10" | quote }}
  resources:
    limits:
      cpu: {{ $opaCPU.limit | default "1" | quote }}
      memory: {{ $opaMemory.limit | default "1Gi" | quote }}
      ephemeral-storage: {{ $opaStorage.limit | default "500Mi" | quote }}
    requests:
      cpu: {{ $opaCPU.request | default "250m" | quote }}
      memory: {{ $opaMemory.request | default "256Mi" | quote }}
      ephemeral-storage: {{ $opaStorage.request | default "100Mi" | quote }}
  volumeMounts:
  - readOnly: true
    mountPath: /opa/policies/policy-main.rego
    name: titan-configs
    subPath: policy-main.rego
  - readOnly: true
    mountPath: /opa/policies/policy-ingress.rego
    name: titan-configs
    subPath: policy-ingress.rego
  - readOnly: true
    mountPath: /opa/policies/policy-tokenspec.rego
    name: titan-configs
    subPath: policy-tokenspec.rego    
      {{- range $k, $v := $opa.customPolicies }}
        {{- if ne $k "tokenSpec" }}
  - readOnly: true
    mountPath: {{ printf "/opa/policies/policy-%s.rego" $k }}
    name: titan-configs
    subPath: {{ printf "policy-%s.rego" $k }}
        {{- end }}
      {{- end }}
  - readOnly: true
    mountPath: /etc/opa.yaml
    name: titan-configs
    subPath: opa.yaml
  - mountPath: /logs/
    name: {{ include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $titanSideCars }}
  {{- end }}
{{- end }}
{{- end }}


