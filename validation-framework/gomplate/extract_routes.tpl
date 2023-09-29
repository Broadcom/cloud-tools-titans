{{- $titanSideCars := .titanSideCars }}
{{- $clusterName := .cluster }}
{{- if $titanSideCars }}
  {{- $envoy := $titanSideCars.envoy }}
  {{- if $envoy }}
    {{- $clusters := $envoy.clusters }}
    {{- if hasKey $clusters "remote-myapp" }}
      {{- $remoteMyApp := index $clusters "remote-myapp" }}
      {{- if $remoteMyApp }}
        {{- $cluster := dict $clusterName $remoteMyApp -}}
          {{- printf "\n" }}
          {{- print (toYaml $cluster) }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}