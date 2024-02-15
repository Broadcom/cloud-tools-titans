{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $ingress := $titanSideCars.ingress }}
  {{- $routes := $ingress.routes }}
  {{- range $routes }}
    {{- $path := "" }}
    {{- $match := .match }}
    {{- if $match }}
      {{- $regex := $match.regex }}
      {{- if $regex }}
        {{- printf "regex=%s\n" $regex }}
        {{- $path = randFromRegex $match.regex }}
        {{- printf "path=%s\n" $path }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}