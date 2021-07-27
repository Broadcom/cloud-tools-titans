{{- define "titan-mesh-helm-lib-chart.containers.ratelimit.containerName" -}}
{{- print "titan-envoy" -}}
{{- end }}
{{- define "titan-mesh-helm-lib-chart.containers.ratelimit" -}}
{{- $titanSideCars := . -}}
{{- if $titanSideCars }}
  {{- $envoyEnabled := eq (include "titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
  {{- $ratelimitEnabled := eq (include "titan-mesh-helm-lib-chart.ratelimitEnabled" $titanSideCars) "true" -}}
  {{- $opa := $titanSideCars.opa -}}
  {{- $ratelimit := $titanSideCars.ratelimit -}}
  {{- $ratelimitCPU := $ratelimit.cpu -}}
  {{- $ratelimitMemory := $ratelimit.memory -}}
  {{- $ratelimitStorage := $ratelimit.ephemeralStorage -}}
  {{- $imageRegistry := $ratelimit.imageRegistry | default $titanSideCars.imageRegistry -}}
  {{- $imageRegistry = ternary "" (printf "%s/" $imageRegistry) (eq $imageRegistry "") -}}
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
    - name: STATSD_PORT
      value: {{ ( $ratelimit.statsdPort | default 8225 ) | quote  }}
    - name: USE_STATSD
      value: {{ $ratelimit.userStatsD | default "False" | quote  }}
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
  terminationMessagePath: /dev/termination-log
  volumeMounts:
    - mountPath: /configs/ratelimit/config.yaml
      name: titan-configs
      subPath: ratelimit_config.yaml
    - mountPath: /logs/
      name: titan-logs    
    {{- end }}
{{- end }}
{{- end }}


