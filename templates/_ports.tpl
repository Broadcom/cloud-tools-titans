{{/*ports to be added to the application's "Service" Kubernetes object under "spec.ports"*/}}
{{- define "titan-mesh-helm-lib-chart.ports" }}
{{- $global := $.Values.global -}}
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
{{- if $titanSideCars }}
  {{- $envoy := $titanSideCars.envoy -}}
  {{- $clusters := $envoy.clusters  }}
  {{- if not $clusters }}
    {{- fail ".Values.titanSideCars.envoy.clusters is required" }}
  {{- end }}
  {{- if not (index $clusters "remote-myapp") }}
    {{- fail ".Values.titanSideCars.envoy.clusters.remote-myapp is required" }}
  {{- end }}
  {{- $remoteMyApp := index $clusters "remote-myapp" }}
  {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
  {{- if $envoyEnabled }}
    {{- $port := $remoteMyApp.port | default "9443" }}
    {{- $tport := $remoteMyApp.targetPort | default $port }}
    {{- $protocol := $remoteMyApp.protocol | default "TCP" }}
- port: {{ $port }}
  targetPort: {{ $tport }}
  protocol: {{ $protocol }}
  name: titan-https-port
  {{- end }}
{{- end }}
{{- end }}