{{/*ports to be added to the application's "Deployment" Kubernetes object under "spec.template.spec.volumes" */}}
{{- define "titan-mesh-helm-lib-chart.volumes.logsVolumeName" -}}
{{- $logs := .logs -}}
{{- printf "%s" ($logs.volumeName | default "titan-logs") -}}
{{- end }}
{{- define "titan-mesh-helm-lib-chart.volumes" -}}
{{- $global := $.Values.global -}}
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
{{- if $titanSideCars }}
  {{- $envoy := $titanSideCars.envoy -}}
  {{- $envoyEnabled := eq (include "titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
  {{- $appName := include "titan-mesh-helm-lib-chart.app-name" . -}}
  {{- if $envoyEnabled }}
    {{- if eq (include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $titanSideCars) "titan-logs" }}
- name: {{ include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $titanSideCars }}
  emptyDir: {}
    {{- end }}
- name: titan-secrets-tls
  secret:
    secretName: {{ $envoy.tlsCert | default (print $appName "-envoy-tls-cert") }}
- name: titan-configs
  configMap:
    name: {{ $.Release.Name }}-{{ printf "%s-titan-configs" $appName }}
    defaultMode: 420
  {{- end }}
{{- end }}
{{- end }}