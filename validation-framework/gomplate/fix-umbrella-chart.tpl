{{- $dependencies := .dependencies }}
{{- $basePath := .path }}
{{- if and $dependencies $basePath }}
  {{- printf "#!/bin/sh\n" }}
  {{- range $dependencies }}
    {{- $name := .name }}
    {{- $respo := .repository }}
    {{- $alias := .alias }}
    {{- $ver := .version }}
    {{- if $alias }}
      {{- printf "mv %s/charts/%s %s/charts/%s\n" $basePath $name $basePath $alias }}
    {{- end }}
  {{- end }}
{{- end }}