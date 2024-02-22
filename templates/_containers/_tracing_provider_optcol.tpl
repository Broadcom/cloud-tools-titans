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
      {{- $provider := $tracing.provider }}
      {{- $deployAsSidecar := $provider.deployAsSidecar | default false -}}
      {{- if $deployAsSidecar }}
        {{- $imageRegistry := $tracing.imageRegistry | default $titanSideCars.imageRegistry -}}
        {{- $imageRegistry = ternary "" (printf "%s/" $imageRegistry) (eq $imageRegistry "") -}}
        {{- $useDynamicConfiguration := $envoy.useDynamicConfiguration | default false }}
        {{- $loadDynamicConfigurationFromGcs := $envoy.loadDynamicConfigurationFromGcs }}
        {{- $loadDynamicConfigurationFromGcsEnabled := ternary $loadDynamicConfigurationFromGcs.enabled false (hasKey $loadDynamicConfigurationFromGcs "enabled" )}}
        {{- $providerConfigPath := $provider.ConfigPath | default "/tracing" -}}
        {{- $providertConfigFileName := $provider.ConfigFileName | default "otel-collector-config.yaml" -}}
        {{- $monitorByEnvoy := $provider.monitorByEnvoy | default false -}}
        {{- $resource := $provider.resource -}}
        {{- $cpu := $resource.cpu -}}
        {{- $memory := $resource.memory -}}
        {{- $storage := $resource.memory }}
- name: {{ include "titan-mesh-helm-lib-chart.containers.opentelmetry.name" . }}
  image: {{ printf "%s%s:%s" $imageRegistry  ($provider.imageName | default "opentelemetry-collector") ($provider.imageTag | default "latest") }}
  imagePullPolicy: IfNotPresent
  command:
    - {{ printf "--config=%s/%s" $providerConfigPath $providertConfigFileName }}
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
      path: {{ $provider.healthCheckPath | default "/" }}
      port: {{ $provider.healthCheckPort | default "13133" }}
      scheme: {{ $provider.healthCheckScheme | default "HTTP" }}
    initialDelaySeconds: 5
    failureThreshold: {{ $provider.livenessFailureThreshold | default "50" }}
    periodSeconds: 5
  readinessProbe:
    httpGet:
      path: {{ $provider.healthCheckPath | default "/" }}
      port: {{ $provider.healthCheckPort | default "13133" }}
      scheme: {{ $provider.healthCheckScheme | default "HTTP" }}
    initialDelaySeconds: 5
    failureThreshold: {{ $provider.readinessFailureThreshold | default "100" }}
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
        {{- if $useDynamicConfiguration }}
          {{- if $loadDynamicConfigurationFromGcsEnabled }}
    - mountPath: {{ $providerConfigPath }}
      name: titan-configs-envoy-data      
          {{- else }}
    - mountPath: {{ printf "%s/%s" $providerConfigPath $providertConfigFileName }}
      name: titan-configs-envoy-dmc
      subPath: {{ $providertConfigFileName }}
          {{- end }}
        {{- else }}
    - mountPath: {{ printf "%s/%s" $providerConfigPath $providertConfigFileName }}
      name: titan-configs
      subPath: {{ $providertConfigFileName }}
        {{- end }}
    - mountPath: /logs/
      name: {{ include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $titanSideCars }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}


