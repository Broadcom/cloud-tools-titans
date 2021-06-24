{{- define "sch.validate.valuesMetadata" -}}
{{- $valuesMetadata := (index . 0) -}}
{{- $prefix := (index . 1) -}}
{{- range $key, $value := $valuesMetadata -}}
  {{- $fullkey:= (list $prefix $key | join "." ) | replace ".valuesMetadata." "" -}}
   {{- if (hasPrefix "map[string]" (typeOf $value)) -}}
     {{- include "sch.validate.valuesMetadata" (list $value $fullkey) -}}
   {{- else -}}
     {{- if eq (typeOf $value) "<nil>" -}}
       {{- fail (cat "Unable to process values-metadata.yaml as the key" $fullkey "has a value of <nil>") -}}
     {{- end -}}
   {{- end -}}
{{- end -}}
{{- end -}}

{{- define "titan-mesh-helm-lib-chart.nameExt" -}}
{{- $meshId := .meshId -}}
{{- $meshGroup := .meshGroup | default "" -}}
{{- if $meshId -}}
{{- printf "-%s%s" $meshId (ternary $meshGroup (printf "-%s" $meshGroup) (eq $meshGroup "")) -}}
{{- else -}}
{{- printf "" -}}
{{- end -}}
{{- end -}}

{{- define "titan-mesh-helm-lib-chart.app-name" -}}
{{- $global := $.Values.global }}
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
{{- default (printf "%s%s" .Chart.Name (include "titan-mesh-helm-lib-chart.nameExt" $titanSideCars)) .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "titan-mesh-helm-lib-chart.enabled" -}}
{{- if . -}}{{- ternary .enabled "true" (hasKey . "enabled") -}}{{- else -}}false{{- end -}}
{{- end -}}

{{/* usage:
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
{{- $envoyEnabled := eq (include "titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
*/}}
{{- define "titan-mesh-helm-lib-chart.envoyEnabled" -}}{{- include "titan-mesh-helm-lib-chart.enabled" .envoy -}}{{- end -}}
{{- define "titan-mesh-helm-lib-chart.opaEnabled" -}}{{- include "titan-mesh-helm-lib-chart.enabled" .opa -}}{{- end -}}
{{- define "titan-mesh-helm-lib-chart.ratelimitEnabled" -}}{{- include "titan-mesh-helm-lib-chart.enabled" .ratelimit -}}{{- end -}}

{{/* usage:
  returns true if any of the titan sidecars are enabled
{{- $hasTitanSidecar := eq (include "titan-mesh-helm-lib-chart.anyTitanSidecarEnabled" .) "true" -}}
*/}}
{{- define "titan-mesh-helm-lib-chart.anyTitanSidecarEnabled" -}}
{{- $global := .Values.global -}}
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
  {{- or (eq (include "titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true") (eq (include "titan-mesh-helm-lib-chart.opaEnabled" $titanSideCars) "true") (eq (include "titan-mesh-helm-lib-chart.ratelimitEnabled" $titanSideCars) "true") -}}
{{- end -}}