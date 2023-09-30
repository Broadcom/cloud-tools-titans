{{- $clusterName := .cluster }}
{{- if and (not (hasKey . "titanSideCars")) (hasKey . "inbound") }}
  {{- $inbound := .inbound -}}
  {{- $_ := set . "titanSideCars" (dict "envoy" (dict "clusters" (dict "remote-myapp" dict)))}}
  {{- $titanSideCars := .titanSideCars }}
  {{- $envoy := $titanSideCars.envoy }}
  {{- $clusters := $envoy.clusters }}
  {{- $remoteMyApp := dict }}
  {{- $public := $inbound.public }}
  {{- if $public }}
    {{- $routes := list }}
    {{- range $public }}
      {{- $uri := .uri }}
      {{- $match := .match }}
      {{- $routes = append $routes (dict "match" (dict $match $uri)) }}
    {{- end }}
    {{- $_ := set $remoteMyApp "routes" $routes }}
    {{- $_ := set $clusters "remote-myapp" $remoteMyApp }}
  {{- end }}
{{- end }}
{{- $titanSideCars := .titanSideCars }}
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