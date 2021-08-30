

{{- define "titan-mesh-helm-lib-chart-legacy.nameExt" -}}
{{- $meshId := .meshId -}}
{{- $meshGroup := .meshGroup | default "" -}}
{{- if $meshId -}}
{{- printf "-%s%s" $meshId (ternary $meshGroup (printf "-%s" $meshGroup) (eq $meshGroup "")) -}}
{{- else -}}
{{- printf "" -}}
{{- end -}}
{{- end -}}

{{- define "titan-mesh-helm-lib-chart-legacy.app-name" -}}
{{- $global := $.Values.global }}
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
{{- default (printf "%s%s" .Chart.Name (include "titan-mesh-helm-lib-chart-legacy.nameExt" $titanSideCars)) .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


