{{- define "titan-mesh-helm-lib-chart.containers.sidecar" -}}
  {{- $config := .config -}}
  {{- $name := .name -}}
  {{- $titanSideCars := .titanSideCars -}}
  {{- $enabled := ternary $config.enabled false (hasKey $config "enabled") }}
  {{- if $enabled }}
    {{- $monitorByEnvoy := $config.monitorByEnvoy | default false -}}
    {{- $cpu := $config.cpu -}}
    {{- $memory := $config.memory -}}
    {{- $storage :=$config.ephemeralStorage -}}
    {{- $imageRegistry := $config.imageRegistry | default $titanSideCars.imageRegistry -}}
    {{- $imageRegistry = ternary "" (printf "%s/" $imageRegistry) (eq $imageRegistry "") -}}
    {{- $configPath := $config.configPath | default (printf "/configs/%s" $name) -}}
    {{- $configFileName := $config.configFileName | default "config.yaml" -}}
- name: {{ $name }}
  image: {{ printf "%s%s:%s" $imageRegistry  $config.imageName ($config.imageTag | default "latest") }}
  imagePullPolicy: IfNotPresent
  command: 
    {{- range $config.command }}
    - {{ . }}
    {{- end }}
    {{- if $config.env }}
  env: 
      {{- range $config.env }}
    - name: {{ .name }}
      value: {{ .value }}
      {{- end }}
    {{- end }}
    {{- if $config.workingDir }}
  workingDir: {{ $config.workingDir }}
    {{- end }}
    {{- if $config.healthCheck -}}
      {{- $healthCheck := $config.healthCheck -}}
      {{- if not $monitorByEnvoy }}
  livenessProbe:
    httpGet:
      path: {{ $healthCheck.path | default "/healthcheck" }}
      port: {{ $healthCheck.port }}
      scheme: {{ $healthCheck.scheme | default "HTTP" }}
    initialDelaySeconds: 5
    failureThreshold: {{ $config.livenessFailureThreshold | default "50" }}
    periodSeconds: 5
  readinessProbe:
    httpGet:
      path: {{ $healthCheck.path | default "/healthcheck" }}
      port: {{ $healthCheck.port }}
      scheme: {{ $healthCheck.scheme | default "HTTP" }}
    initialDelaySeconds: 5
    failureThreshold: {{ $config.readinessFailureThreshold | default "100" }}
    periodSeconds: 5
  resources:
    limits:
      cpu: {{ $cpu.limit | default "1" | quote }}
      memory: {{ $memory.limit | default "1Gi" | quote }}
      ephemeral-storage: {{ $storage.limit | default "500Mi" | quote }}
    requests:
      cpu: {{ $cpu.request | default "250m" | quote }}
      memory: {{ $memory.request | default "256Mi" | quote }}
      ephemeral-storage: {{ $storage.request | default "100Mi" | quote }}
      {{- end }}
    {{- end }}
  terminationMessagePath: /dev/termination-log
  volumeMounts:
    - mountPath: {{ printf "%s/%s" $configPath $configFileName }}
      name: titan-sidecar-configs
      subPath: {{ $configFileName }}
    - mountPath: /logs/
      name: {{ include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $titanSideCars }}
  {{- end }}
{{- end }}



