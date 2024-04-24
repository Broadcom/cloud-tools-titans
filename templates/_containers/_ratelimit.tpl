{{- define "titan-mesh-helm-lib-chart.containers.ratelimit.containerName" -}}
{{- print "titan-ratelimit" -}}
{{- end }}
{{- define "titan-mesh-helm-lib-chart.containers.ratelimit" -}}
{{- $titanSideCars := . -}}
{{- if $titanSideCars }}
  {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
  {{- $ratelimitEnabled := eq (include "static.titan-mesh-helm-lib-chart.ratelimitEnabled" $titanSideCars) "true" -}}
  {{- $envoy := $titanSideCars.envoy -}}
  {{- $useDynamicConfiguration := $envoy.useDynamicConfiguration | default false }}
  {{- $loadDynamicConfigurationFromGcs := $envoy.loadDynamicConfigurationFromGcs }}
  {{- $loadDynamicConfigurationFromGcsEnabled := ternary $loadDynamicConfigurationFromGcs.enabled false (hasKey $loadDynamicConfigurationFromGcs "enabled" )}}
  {{- $ratelimit := $titanSideCars.ratelimit -}}
  {{- $ratelimitMonitorByEnvoy := $ratelimit.monitorByEnvoy -}}
  {{- $ratelimitCPU := $ratelimit.cpu -}}
  {{- $ratelimitMemory := $ratelimit.memory -}}
  {{- $ratelimitStorage := $ratelimit.ephemeralStorage -}}
  {{- $imageRegistry := $ratelimit.imageRegistry | default $titanSideCars.imageRegistry -}}
  {{- $imageRegistry = ternary "" (printf "%s/" $imageRegistry) (eq $imageRegistry "") -}}
  {{- $ingress := $titanSideCars.ingress }}
  {{- $envoy := $titanSideCars.envoy }}
  {{- $ratelimitConfigPath := $ratelimit.configPath | default "/configs/ratelimit/config" -}}
  {{- $ratelimitConfigFileName := $ratelimit.configFileName | default "ratelimit_config.yaml" -}}
  {{- $ratelimitConfigVolumeMountPath := $ratelimit.configVolumeMountPath | default "/configs" -}}
  {{- $clusters := $envoy.clusters }}
  {{- $localApp := index $clusters "local-myapp" }}

  {{- $gateway := $localApp.gateway }}
  {{- $gatewayEnable := $gateway.enabled }}
  {{- $routes := list }}
  {{- if $gatewayEnable }}
    {{- range $cn, $cv := $clusters }}
      {{- if and (ne $cn "local-myapp") (ne $cn "remote-myapp") }}
        {{- range $cv.routes }}
          {{- $newcluster := dict "cluster" $cn }}
          {{- $routes = append $routes (dict "match" .match "route" $newcluster "ratelimit" .ratelimit) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- else }}
    {{- $routes = $ingress.routes }}
    {{- if and $ingress (not $routes) }}
      {{- if ternary $ingress.enabled true (hasKey $ingress "enabled") }}
        {{ $routes = $localApp.routes }}
      {{- end }}
    {{- end }}
    {{- $additionalRoutes := $ingress.additionalRoutes }}
    {{- if $additionalRoutes }}
      {{- if $routes }}
        {{- $routes = concat $additionalRoutes $routes }}
      {{- else }}
        {{- $routes = $additionalRoutes }}
      {{- end }}
    {{- end }}
  {{- end }}
  
  {{- if and $envoyEnabled $ratelimitEnabled }}
- name: {{include "titan-mesh-helm-lib-chart.containers.ratelimit.containerName" . }}
  image: {{ printf "%s%s:%s" $imageRegistry  ($ratelimit.imageName | default "ratelimit") ($ratelimit.imageTag | default "latest") }}
  imagePullPolicy: IfNotPresent
  command:
    - sh
    - '-c'
    - >
      exec /bin/ratelimit  2>&1 | tee -a /logs/ratelimit.log
  env:
    - name: RUNTIME_ROOT
      value: {{ $ratelimit.runTimeRoot | default "/configs" | quote }}
    - name: RUNTIME_SUBDIRECTORY
      value: {{ $ratelimit.runTimeSubDirectory | default "ratelimit" | quote }}
    - name: LOG_FOLDER
      value: {{ $ratelimit.log | default "/logs" | quote }}
    - name: LOG_LEVEL
      value: {{ $ratelimit.logLevel | default "INFO"  | quote }}
    - name: REDIS_POOL_SIZE
      value: {{ ( $ratelimit.redisPoolSize | default 2 )  | quote  }}
    - name: REDIS_URL
      value: {{ $ratelimit.redisUrl | default "10.251.54.3:6379" | quote }}
    - name: REDIS_USE_TLS
      value: {{ $ratelimit.redisUseTls | default "False" | quote }}
    - name: REDIS_SOCKET_TYPE
      value: {{ $ratelimit.redisSocketType | default "tcp" | quote }}
    - name: REDIS_AUTH
      value: {{ $ratelimit.redisAuth| default "" | quote  }}
    - name: USE_STATSD
      value: {{ $ratelimit.userStatsD | default "true" | quote  }}
    - name: STATSD_PORT
      value: {{ ( $ratelimit.statsdPort | default "8125" ) | quote  }}
    - name: STATSD_PROTOCOL
      value: {{ ( $ratelimit.statsdProtocol | default "udp" ) | quote  }}
    - name: STATSD_HOST
      value: {{ ( $ratelimit.statsdHost | default "127.0.0.1" ) | quote  }}
    - name: NEAR_LIMIT_RATIO
      value: {{ ( $ratelimit.nearLimitRatio | default "0.8" ) | quote  }}
    - name: DETAILED_METRICS_MODE
      value: {{ ( $ratelimit.detailedMetricsMode | default "true" ) | quote  }}
    - name: SHADOW_MODE
      value: {{ ( $ratelimit.shadowMode | default "false" ) | quote  }}
    - name: PORT
      value: {{ ( $ratelimit.port | default 8070 ) | quote  }}
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
    {{- if not $ratelimitMonitorByEnvoy }}
  livenessProbe:
    httpGet:
      path: {{ $ratelimit.healthCheckPath | default "/healthcheck" }}
      port: {{ $ratelimit.healthCheckPort | default "8070" }}
      scheme: {{ $ratelimit.healthCheckScheme | default "HTTP" }}
    initialDelaySeconds: 5
    failureThreshold: {{ $ratelimit.livenessFailureThreshold | default "50" }}
    periodSeconds: 5
  readinessProbe:
    httpGet:
      path: {{ $ratelimit.healthCheckPath | default "/healthcheck" }}
      port: {{ $ratelimit.healthCheckPort | default "8070" }}
      scheme: {{ $ratelimit.healthCheckScheme | default "HTTP" }}
    initialDelaySeconds: 5
    failureThreshold: {{ $ratelimit.readinessFailureThreshold | default "100" }}
    periodSeconds: 5
  resources:
    limits:
      cpu: {{ $ratelimitCPU.limit | default "1" | quote }}
      memory: {{ $ratelimitMemory.limit | default "1Gi" | quote }}
      ephemeral-storage: {{ $ratelimitStorage.limit | default "500Mi" | quote }}
    requests:
      cpu: {{ $ratelimitCPU.request | default "250m" | quote }}
      memory: {{ $ratelimitMemory.request | default "256Mi" | quote }}
      ephemeral-storage: {{ $ratelimitStorage.request | default "100Mi" | quote }}
    {{- end }}
  terminationMessagePath: /dev/termination-log
  volumeMounts:
    {{- if $useDynamicConfiguration }}
      {{- if $loadDynamicConfigurationFromGcsEnabled }}
    - mountPath: {{ $ratelimitConfigVolumeMountPath }}
      name: titan-configs-envoy-data      
      {{- else }}
    - mountPath: {{ printf "%s/%s" $ratelimitConfigPath $ratelimitConfigFileName }}
      name: titan-configs-envoy-dmc
      subPath: {{ $ratelimitConfigFileName }}
      {{- end }}
    {{- else }}
    - mountPath: {{ printf "%s/%s" $ratelimitConfigPath $ratelimitConfigFileName }}
      name: titan-configs
      subPath: {{ $ratelimitConfigFileName }}
    {{- end }}
    - mountPath: /logs/
      name: {{ include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $titanSideCars }}
    {{- end }}
{{- end }}
{{- end }}


