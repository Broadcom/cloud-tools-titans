{{- define "titan-mesh-helm-lib-chart.outbund.import" }}
  {{- if and (hasKey . "titanSideCars") (hasKey . "outbound") }}
    {{- $titanSideCars := .titanSideCars }}
    {{- if not (hasKey $titanSideCars "egress") }}
      {{- $outbound := .outbound -}}
      {{- $routes := list }}
      {{- range $k, $v := $outbound }}
        {{- if $v.enabled }}
          {{- $routes = append $routes (dict "route" (dict "cluster" $k)) }}
        {{- end }}
      {{- end }}
      {{- if gt (len $routes) 0 }}
        {{- $_ := set $titanSideCars "egress" (dict "routes" $routes) }}
      {{- end }}    
    {{- end }}
  {{- end }}
{{- end }}
