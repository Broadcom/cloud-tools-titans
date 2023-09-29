{{- $select := .select -}}
{{- range $key, $val := .data }}
  {{- if eq $key $select -}}
    {{- print $val -}}
  {{- end -}}
{{- end -}}