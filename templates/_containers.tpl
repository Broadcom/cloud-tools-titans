{{- define "titan-mesh-helm-lib-chart.containers" -}}
{{- $global := $.Values.global -}}
{{- $namespace := $.Release.Namespace }}
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
{{- if $titanSideCars }}
  {{- $imageRegistry := coalesce $titanSideCars.imageRegistry .Values.imageRegistry $global.imageRegistry $global.dockerRegistry }}
  {{- $appName := include "titan-mesh-helm-lib-chart.app-name" . -}}
  {{- if $imageRegistry }}
    {{- if not $titanSideCars.imageRegistry }}
      {{- $_ := set $titanSideCars "imageRegistry" $imageRegistry -}}
    {{- end }}
  {{- else  }}
    {{- $_ := set $titanSideCars "imageRegistry" "" -}}
  {{- end }}
  {{- include "titan-mesh-helm-lib-chart.containers.envoy" (dict "titanSideCars" $titanSideCars "appName" $appName "namespace" $namespace) -}}
  {{- include "titan-mesh-helm-lib-chart.containers.opa" $titanSideCars -}}
  {{- include "titan-mesh-helm-lib-chart.containers.ratelimit" $titanSideCars -}}
  {{- $customTpls := $titanSideCars.customTpls }}
  {{- $sideCars := $customTpls.sideCars }}
  {{- printf "\n" -}}
  {{- range $sideCarName, $sideCarValue := $sideCars }}
    {{- include "titan-mesh-helm-lib-chart.containers.sidecar" (dict "titanSideCars" $titanSideCars "config" ($sideCarValue.config | default dict) "name" ($sideCarName | default (printf "sidecar-%s" (randAscii 3)))) }}
  {{- end }}
{{- end }}
{{- end }}