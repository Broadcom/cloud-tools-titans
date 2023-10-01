{{- define "titan-mesh-helm-lib-chart.configmap" }}
  {{- $global := $.Values.global | dict "titanSideCars" (dict "envoy" dict) -}}
  {{- $icdmService := $.Values.service  }}
  {{- $icdmInbound := $.Values.inbound  }}
  {{- $icdmOutbound := $.Values.outbound  }}
  {{- include "titan-mesh-helm-lib-chart.envoy.canary.icdm.clusters" (dict "titanSideCars" $global.titanSideCars "service" $icdmService "inbound" $icdmInbound "outbound" $icdmOutbound) -}}
  {{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
  {{- if $titanSideCars }}
    {{- if not (hasKey $titanSideCars "envoy") -}}
    {{- $_ := set $titanSideCars "envoy" (dict "clusters" dict) -}}
    {{- end -}}
    {{- $envoy := $titanSideCars.envoy -}}
    {{- $validation := $titanSideCars.validation -}}
    {{- $validationEnabled := false -}}
    {{- if $validation -}}
      {{- $validationEnabled = ternary $validation.enabled true (hasKey $validation "enabled") -}}
    {{- end }}
    {{- if $validationEnabled -}}
      {{- $_ := set $envoy "clusters" (mergeOverwrite (deepCopy $envoy.clusters) $validation.clusters) -}}
    {{- end -}}
    {{- include "titan-mesh-helm-lib-chart.envoy.canary.clusters.map" (dict "envoy" $envoy) -}}
    {{- $logs := $titanSideCars.logs -}}
    {{- $opa := $titanSideCars.opa -}}
    {{- $ratelimit := $titanSideCars.ratelimit -}}
    {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
    {{- $opaEnabled := eq (include "static.titan-mesh-helm-lib-chart.opaEnabled" $titanSideCars) "true" -}}
    {{- $ratelimitEnabled := eq (include "static.titan-mesh-helm-lib-chart.ratelimitEnabled" $titanSideCars) "true" -}}
    {{- $appName := include "titan-mesh-helm-lib-chart.app-name" . -}}
    {{- if $envoyEnabled }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $.Release.Name }}-{{ printf "%s-titan-configs" $appName }}
data:
{{ include "titan-mesh-helm-lib-chart.configs.envoy" (dict "titanSideCars" $titanSideCars "appName" $appName "releaseNamespace" .Release.Namespace "chartName" .Chart.Name) | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds" . | indent 2 }}
      {{- if $opaEnabled }}
{{ include "titan-mesh-helm-lib-chart.configs.opa" . | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.opa-policy" . | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.opa-policy-tokenspec" . | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.opa-policy-ingress" . | indent 2 }}
        {{- range $k, $v := $opa.customPolicies }}
          {{- if ne $k "tokenSpec" }}
  {{ printf "policy-%s.rego: |" $k }}
{{ $v | indent 4 }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- if $ratelimitEnabled }}
{{ include "titan-mesh-helm-lib-chart.configs.ratelimit" . | indent 2 }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}