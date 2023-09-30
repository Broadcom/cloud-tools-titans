{{- $dependencies := .dependencies }}
{{- $basePath := .path }}
{{- if and $dependencies $basePath }}
  {{- printf "#!/bin/bash\n" }}
  {{- printf "rm -rf ./build\n" }}
  {{- printf "mkdir -p ./build/charts\n" }}
  {{- range $dependencies }}
    {{- $name := .name }}
    {{- $respo := .repository }}
    {{- $alias := .alias }}
    {{- $ver := .version }}
    {{- $tarball := printf "%s-%s.tgz" $name $ver }}
    {{- $cpath := printf "%s/charts/%s" $basePath $name }}
    {{- $tpath := printf "%s/charts/%s" $basePath $tarball }}
    {{- if $alias }}
      {{- $dpath := printf "./build/charts/%s" $alias }}
      {{- printf "[ -f %s ] && mkdir -p %s && tar xf %s --strip 1 -C %s\n" $tpath $dpath $tpath $dpath }}
      {{- printf "[ -d %s ] && cp -r %s %s\n" $cpath $cpath $dpath }}
    {{- else }}
      {{- $dpath := printf "./build/charts/%s" $name }}
      {{- printf "[ -f %s ] && mkdir -p %s && tar xf %s --strip 1 -C %s\n" $tpath $dpath $tpath $dpath }}
      {{- printf "[ -d %s ] && cp -r %s %s\n" $cpath $cpath $dpath }}
    {{- end }}
  {{- end }}
{{- end }}
