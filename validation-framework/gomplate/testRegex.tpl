{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $ingress := $titanSideCars.ingress }}
  {{- $routes := $ingress.routes }}
  {{- range $routes }}
    {{- $route := .route }}
    {{- $path := "" }}
    {{- $match := .match }}
    {{- if $match }}
      {{- $regex := $match.regex }}
      {{- if $regex }}
        {{- printf "#######\n" }}
        {{- printf "regex=%s\n" $regex }}
        {{- $path = randFromUrlRegex $match.regex }}
        {{- printf "path=%s\n" $path }}
        {{/* {{- $regexRewrite := $route.regexRewrite }}
        {{- $regexPattern := $regexRewrite.pattern }}
        {{- print "$regexPattern=" $regexPattern "\n" }}
        {{- $regexSubstitution := $regexRewrite.substitution }}
        {{- print "$regexSubstitution=" $regexSubstitution "\n" }}
        {{- $subStrs := split "\\" $regexSubstitution }}
        {{- $newPath := $regexSubstitution }}
        {{- $count := 1 }}
        {{- range $subStrs }}
          {{- if lt $count (len $subStrs) }}
            {{- $newPath = $newPath | replace (printf "\\%d" $count) "[^/]+" }}
            {{- $count = add1 $count }}
          {{- end }}
        {{- end }}
        {{- print "$newMatchPattern=" $newPath "\n" }} */}}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}