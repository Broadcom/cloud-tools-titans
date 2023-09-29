{{- range $key, $val := . }}
  {{- $typeOf := printf "%s" (typeOf $val) }}
  {{- if ne $typeOf "string" }}
    {{- if eq $key "dependencies" }}
      {{- $dependencies := $val }}
      {{- range $dependencies }}
        {{- printf "name: %s\n" .name }}
        {{- printf "version: %s\n" .version }}
        {{- printf "repository: %s\n" .repository }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}