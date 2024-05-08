{{- define "titan-mesh-helm-lib-chart.configmap" }}
  {{- $global := $.Values.global -}}
  {{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
  {{- if $titanSideCars }}
    {{- if not (hasKey $titanSideCars "envoy") -}}
      {{- $_ := set $titanSideCars "envoy" (dict "clusters" dict) -}}
    {{- end -}}
    {{- $envoy := $titanSideCars.envoy -}}
    {{- $useDynamicConfiguration := $envoy.useDynamicConfiguration | default false }}
    {{- $useSeparateConfigMaps := $envoy.useSeparateConfigMaps | default false }}
    {{- $loadDynamicConfigurationFromGcs := $envoy.loadDynamicConfigurationFromGcs }}
    {{- $loadDynamicConfigurationFromGcsEnabled := ternary $loadDynamicConfigurationFromGcs.enabled false (hasKey $loadDynamicConfigurationFromGcs "enabled" )}}
    {{- $generateConfigMap := true }}
    {{- if $loadDynamicConfigurationFromGcsEnabled }}
      {{- $generateConfigMap = ternary $envoy.generateConfigmpForGcs false (hasKey $envoy "generateConfigmpForGcs") }}
    {{- end }}
    {{- $validation := $titanSideCars.validation -}}
    {{- $validationEnabled := false -}}
    {{- if $validation -}}
      {{- $validationEnabled = ternary $validation.enabled true (hasKey $validation "enabled") -}}
    {{- end }}
    {{- if $validationEnabled -}}
      {{- $_ := set $envoy "clusters" (mergeOverwrite (deepCopy $envoy.clusters) $validation.clusters) -}}
    {{- end -}}
    {{- $logs := $titanSideCars.logs -}}
    {{- $opa := $titanSideCars.opa -}}
    {{- $ratelimit := $titanSideCars.ratelimit -}}
    {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
    {{- $opaEnabled := eq (include "static.titan-mesh-helm-lib-chart.opaEnabled" $titanSideCars) "true" -}}
    {{- $ratelimitEnabled := eq (include "static.titan-mesh-helm-lib-chart.ratelimitEnabled" $titanSideCars) "true" -}}
    {{- $appName := include "titan-mesh-helm-lib-chart.app-name" . -}}
    {{- $customTpls := $titanSideCars.customTpls }}
    {{- $sideCars := $customTpls.sideCars }}
    {{- if $envoyEnabled }}
      {{- if $useDynamicConfiguration }}
        {{- if $generateConfigMap }}
          {{- if $useSeparateConfigMaps }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $.Release.Name }}-{{ printf "%s-titan-configs-envoy-dmc" $appName }}
data:
{{ include "titan-mesh-helm-lib-chart.configs.envoy.dmc" (dict "titanSideCars" $titanSideCars "appName" $appName "releaseNamespace" .Release.Namespace "chartName" .Chart.Name) | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds" . | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds-validation" . | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds-validation-pub" . | indent 2 }}
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
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $.Release.Name }}-{{ printf "%s-titan-configs-envoy-cds" $appName }}
data:
{{ include "titan-mesh-helm-lib-chart.configs.envoy.cds" (dict "titanSideCars" $titanSideCars "appName" $appName "releaseNamespace" .Release.Namespace "chartName" .Chart.Name) | indent 2 }}

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $.Release.Name }}-{{ printf "%s-titan-configs-envoy-lds" $appName }}
data:
{{ include "titan-mesh-helm-lib-chart.configs.envoy.lds" (dict "titanSideCars" $titanSideCars "appName" $appName "releaseNamespace" .Release.Namespace "chartName" .Chart.Name) | indent 2 }}
          {{- else }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $.Release.Name }}-{{ printf "%s-titan-configs-envoy-dmc" $appName }}
data:
{{ include "titan-mesh-helm-lib-chart.configs.envoy.dmc" (dict "titanSideCars" $titanSideCars "appName" $appName "releaseNamespace" .Release.Namespace "chartName" .Chart.Name) | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds" . | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds-validation" . | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds-validation-pub" . | indent 2 }}
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
{{ include "titan-mesh-helm-lib-chart.configs.envoy.cds" (dict "titanSideCars" $titanSideCars "appName" $appName "releaseNamespace" .Release.Namespace "chartName" .Chart.Name) | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy.lds" (dict "titanSideCars" $titanSideCars "appName" $appName "releaseNamespace" .Release.Namespace "chartName" .Chart.Name) | indent 2 }}

          {{- end }}
        {{- end }}
      {{- else }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $.Release.Name }}-{{ printf "%s-titan-configs" $appName }}
data:
{{ include "titan-mesh-helm-lib-chart.configs.envoy" (dict "titanSideCars" $titanSideCars "appName" $appName "releaseNamespace" .Release.Namespace "chartName" .Chart.Name) | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds" . | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds-validation" . | indent 2 }}
{{ include "titan-mesh-helm-lib-chart.configs.envoy-sds-validation-pub" . | indent 2 }}
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
    {{- if $sideCars }}
      {{- $hasConfigTpl := false -}}
      {{- range $sideCarName, $sideCarValue := $sideCars -}}
        {{- if $sideCarValue.configTpl -}}
          {{- $hasConfigTpl = true -}}
        {{- end -}}
      {{- end -}}
      {{- if $hasConfigTpl }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $.Release.Name }}-{{ printf "%s-titan-sidecar-configs" $appName }}
data:
        {{- range $sideCarName, $sideCarValue := $sideCars -}}
          {{- include $sideCarValue.configTpl $ | nindent 2 }}
        {{- end -}}     
      {{- end }}
    {{- end }} 
  {{- end }}
{{- end }}