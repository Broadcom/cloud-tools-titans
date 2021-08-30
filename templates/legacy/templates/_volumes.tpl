{{/*ports to be added to the application's "Deployment" Kubernetes object under "spec.template.spec.volumes" */}}
{{- define "titan-mesh-helm-lib-chart-legacy.volumes.logsVolumeName" -}}
{{- $titanSideCars := .titanSideCars -}}
{{- $logs := $titanSideCars.logs | default .logs -}}
{{- $logs.volumeName | default "titan-logs" -}}
{{- end }}
{{- define "titan-mesh-helm-lib-chart-legacy.volumes" -}}
{{- $global := $.Values.global -}}
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
{{- $_ := set $ "titanSideCars" $titanSideCars }}
{{- if $titanSideCars }}
  {{- $envoy := $titanSideCars.envoy -}}
  {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
  {{- $appName := include "titan-mesh-helm-lib-chart-legacy.app-name" . -}}
  {{- if $envoyEnabled }}
    {{- if eq (include "titan-mesh-helm-lib-chart-legacy.volumes.logsVolumeName" $ ) "titan-logs" }}
- name: {{ include "titan-mesh-helm-lib-chart-legacy.volumes.logsVolumeName" $ }}
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
