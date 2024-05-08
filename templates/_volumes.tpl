{{/*ports to be added to the application's "Deployment" Kubernetes object under "spec.template.spec.volumes" */}}
{{- define "titan-mesh-helm-lib-chart.volumes.logsVolumeName" -}}
  {{- $titanSideCars := .titanSideCars -}}
  {{- $logs := $titanSideCars.logs | default .logs -}}
  {{- $logs.volumeName | default "titan-logs" -}}
{{- end }}
{{- define "titan-mesh-helm-lib-chart.volumes" -}}
  {{- $global := $.Values.global -}}
  {{- $namespace := $.Release.Namespace -}}
  {{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
  {{- $_ := set $ "titanSideCars" $titanSideCars }}
  {{- if $titanSideCars }}
    {{- $envoy := $titanSideCars.envoy -}}
    {{- $useDynamicConfiguration := $envoy.useDynamicConfiguration | default false }}
    {{- $useSeparateConfigMaps := $envoy.useSeparateConfigMaps | default false }}
    {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
    {{- $appName := include "titan-mesh-helm-lib-chart.app-name" . -}}
    {{- if $envoyEnabled }}
      {{- $loadDynamicConfigurationFromGcs := $envoy.loadDynamicConfigurationFromGcs }}
      {{- $loadDynamicConfigurationFromGcsEnabled := ternary $loadDynamicConfigurationFromGcs.enabled false (hasKey $loadDynamicConfigurationFromGcs "enabled") }}
      {{- $customTpls := $titanSideCars.customTpls }}
      {{- $sideCars := $customTpls.sideCars }}
      {{- if eq (include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $ ) "titan-logs" }}
- name: {{ include "titan-mesh-helm-lib-chart.volumes.logsVolumeName" $ }}
  emptyDir: {}
      {{- end }}
- name: titan-secrets-tls
  secret:
    secretName: {{ $envoy.tlsCert | default (print $appName "-envoy-tls-cert") }}
      {{- if $envoy.intTlsCert }}
- name: titan-secrets-tls-int
  secret:
    secretName: {{ $envoy.intTlsCert }}
      {{- end }}
      {{- if $useDynamicConfiguration }}
        {{- if $loadDynamicConfigurationFromGcsEnabled }}
- name: titan-configs-envoy-data
  csi:
    driver: {{ $loadDynamicConfigurationFromGcs.csiDriver | default "gcsfuse.csi.storage.gke.io" }}
    volumeAttributes:
      bucketName: {{ $loadDynamicConfigurationFromGcs.bucketName | default "sedicdsaas-dev-stage-envoy" }}
      mountOptions: {{ $loadDynamicConfigurationFromGcs.mountOptions | default (printf "implicit-dirs,only-dir=%s/%s" $namespace $appName) | quote }} 
        {{- else }}
          {{- if $useSeparateConfigMaps }}
- name: titan-configs-envoy-dmc
  configMap:
    name: {{ $.Release.Name }}-{{ printf "%s-titan-configs-envoy-dmc" $appName }}
    defaultMode: 420
- name: titan-configs-envoy-cds
  configMap:
    name: {{ $.Release.Name }}-{{ printf "%s-titan-configs-envoy-cds" $appName }}
    defaultMode: 420
- name: titan-configs-envoy-lds
  configMap:
    name: {{ $.Release.Name }}-{{ printf "%s-titan-configs-envoy-lds" $appName }}
    defaultMode: 420
          {{- else }}
- name: titan-configs-envoy-dmc
  configMap:
    name: {{ $.Release.Name }}-{{ printf "%s-titan-configs-envoy-dmc" $appName }}
    defaultMode: 420
          {{- end }}
        {{- end }}
      {{- else }}
- name: titan-configs
  configMap:
    name: {{ $.Release.Name }}-{{ printf "%s-titan-configs" $appName }}
    defaultMode: 420
      {{- end }}
      {{- if $sideCars }}
        {{- $hasConfigTpl := false -}}
        {{- range $sideCarName, $sideCarValue := $sideCars -}}
          {{- if $sideCarValue.configTpl -}}
            {{- $hasConfigTpl = true -}}
          {{- end -}}
        {{- end -}}
        {{- if $hasConfigTpl }}
- name: titan-sidecar-configs
  configMap:
    name: {{ $.Release.Name }}-{{ printf "%s-titan-sidecar-configs" $appName }}
    defaultMode: 420
        {{- end }}
      {{- end }}    
    {{- end }}
  {{- end }}
{{- end }}