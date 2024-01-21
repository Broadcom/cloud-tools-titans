{{/* annotations to be added to the application's "Deployment" Kubernetes object under "spec.template.metadata.annotations" */}}
{{- define "titan-mesh-helm-lib-chart.deployment.annotations" -}}
  {{- $global := $.Values.global -}}
  {{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
  {{- $_ := set $ "titanSideCars" $titanSideCars }}
  {{- if $titanSideCars }}
    {{- $envoy := $titanSideCars.envoy -}}
    {{- $useDynamicConfiguration := $envoy.useDynamicConfiguration | default false }}
    {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
    {{- $appName := include "titan-mesh-helm-lib-chart.app-name" . -}}
    {{- if and $envoyEnabled $useDynamicConfiguration }}
      {{- $loadDynamicConfigurationFromGcs := $envoy.loadDynamicConfigurationFromGcs }}
      {{- $loadDynamicConfigurationFromGcsEnabled := ternary $loadDynamicConfigurationFromGcs.enabled false (hasKey $loadDynamicConfigurationFromGcs "enabled" )}}
      {{- if $loadDynamicConfigurationFromGcsEnabled }}
        {{- range $k, $v := $loadDynamicConfigurationFromGcs.annotations }}
{{ printf "%s: %s" $k ($v | quote) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}