{{- define "titan-mesh-helm-lib-chart.containers.opentelmetry.name" -}}
  {{- print "titan-opentelmetry" -}}
{{- end }}
{{- define "titan-mesh-helm-lib-chart.containers.opentelmetry" -}}
  {{- $titanSideCars := . -}}
  {{- if $titanSideCars }}
    {{- $envoy := $titanSideCars.envoy -}}
    {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
    {{- $tracing := $titanSideCars.tracing }}
    {{- $tracingEnabled := ternary $tracing.enabled false (hasKey $tracing "enabled") }}
    {{- if $tracingEnabled }}
      {{- $collector := $tracing.collector }}
      {{- $deployAsSidecar := $collector.deployAsSidecar | default false -}}
      {{- if $deployAsSidecar }}
        {{- $imageRegistry := $tracing.imageRegistry | default $titanSideCars.imageRegistry -}}
        {{- $imageRegistry = ternary "" (printf "%s/" $imageRegistry) (eq $imageRegistry "") -}}
        {{- $useDynamicConfiguration := $envoy.useDynamicConfiguration | default false }}
        {{- $loadDynamicConfigurationFromGcs := $envoy.loadDynamicConfigurationFromGcs }}
        {{- $loadDynamicConfigurationFromGcsEnabled := ternary $loadDynamicConfigurationFromGcs.enabled false (hasKey $loadDynamicConfigurationFromGcs "enabled" )}}
        {{- $collectorConfigPath := $collector.ConfigPath | default "/tracing" -}}
        {{- $collectortConfigFileName := $collector.ConfigFileName | default "otel-collector-config.yaml" -}}
        {{- $monitorByEnvoy := $collector.monitorByEnvoy | default false -}}
        {{- $resource := $collector.resource -}}
        {{- $cpu := $resource.cpu -}}
        {{- $memory := $resource.memory -}}
        {{- $storage := $resource.memory }}
- name: {{ include "titan-mesh-helm-lib-chart.containers.opentelmetry.name" . }}
  image: {{ printf "%s%s:%s" $imageRegistry  ($collector.imageName | default "opentelemetry-collector") ($collector.imageTag | default "latest") }}
  imagePullPolicy: IfNotPresent
  command:
    - {{ printf "--config=%s/%s" $collectorConfigPath $collectortConfigFileName }}
  env:
    - name: NAMESPACE
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.namespace
    - name: POD_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.name
    - name: POD_ID
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.uid
        {{- if not $monitorByEnvoy }}
  livenessProbe:
    httpGet:
      path: {{ $collector.healthCheckPath | default "/" }}
      port: {{ $collector.healthCheckPort | default "13133" }}
      scheme: {{ $collector.healthCheckScheme | default "HTTP" }}
    initialDelaySeconds: 5
    failureThreshold: {{ $collector.livenessFailureThreshold | default "50" }}
    periodSeconds: 5
  readinessProbe:
    httpGet:
      path: {{ $collector.healthCheckPath | default "/" }}
      port: {{ $collector.healthCheckPort | default "13133" }}
      scheme: {{ $collector.healthCheckScheme | default "HTTP" }}
    initialDelaySeconds: 5
    failureThreshold: {{ $collector.readinessFailureThreshold | default "100" }}
    periodSeconds: 5
  resources:
    limits:
      cpu: {{ $cpu.limit | default "500m" | quote }}
      memory: {{ $memory.limit | default "512Mi" | quote }}
      ephemeral-storage: {{ $storage.limit | default "500Mi" | quote }}
    requests:
      cpu: {{ $cpu.request | default "250m" | quote }}
      memory: {{ $memory.request | default "256Mi" | quote }}
      ephemeral-storage: {{ $storage.request | default "100Mi" | quote }}
        {{- end }}
  terminationMessagePath: /dev/termination-log
  volumeMounts:
    - mountPath: {{ printf "%s/%s" $collectorConfigPath $collectortConfigFileName }}
      name: titan-configs-tracing-otpl
      subPath: {{ $collectortConfigFileName }}
    - mountPath: /logs/
      name: {{ include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $titanSideCars }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}


