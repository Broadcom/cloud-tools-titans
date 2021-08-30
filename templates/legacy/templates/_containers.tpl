{{- define "titan-mesh-helm-lib-chart-legacy.containers" -}}
{{- $global := $.Values.global -}}
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
{{- if $titanSideCars }}
  {{- $imageRegistry := coalesce $titanSideCars.imageRegistry .Values.imageRegistry $global.imageRegistry $global.dockerRegistry }}
  {{- $appName := include "titan-mesh-helm-lib-chart-legacy.app-name" . -}}
  {{- if $imageRegistry }}
    {{- if not $titanSideCars.imageRegistry }}
      {{- $_ := set $titanSideCars "imageRegistry" $imageRegistry -}}
    {{- end }}
  {{- else  }}
    {{- $_ := set $titanSideCars "imageRegistry" "" -}}
  {{- end }}
  {{- include "titan-mesh-helm-lib-chart-legacy.containers.envoy" (dict "titanSideCars" $titanSideCars "appName" $appName) -}}
  {{- include "titan-mesh-helm-lib-chart-legacy.containers.opa" $titanSideCars -}}
  {{- include "titan-mesh-helm-lib-chart-legacy.containers.ratelimit" $titanSideCars -}}
{{- end }}
{{- end }}
