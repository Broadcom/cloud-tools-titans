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
        {{- printf "regex=%s\n" $regex }}
        {{- $path = randFromRegex $match.regex }}
        {{- printf "path=%s\n" $path }}
        {{- $regexRewrite := $route.regexRewrite }}
        {{- $regexPattern := $regexRewrite.pattern }}
        {{- print "$regexPattern=" $regexPattern "\n" }}
        {{- $regexSubstitution := $regexRewrite.substitution }}
        {{- print "$regexSubstitution=" $regexSubstitution "\n" }}
        {{- $subStrs := split "\\" $regexSubstitution }}
        {{- print "$subStrs=" $subStrs "\n" }}
        {{- $newPath := $regexSubstitution }}
        {{- print "$newPath=" $newPath "\n" }}
        {{- $count := 1 }}
        {{- range $subStrs }}
          {{- if lt $count (len $subStrs) }}
            {{- printf "replace\n" }}
            {{- $newPath = $newPath | replace (printf "\\%d" $count) "[^/]+" }}
            {{- $count = add1 $count }}
          {{- end }}
        {{- end }}
        {{- print "$newPath=" $newPath "\n" }}
        {{- if (regexMatch $newPath "/epmp/v1/1234/users/idproviders") }}
          {{- printf "match %s with %s\n" "/epmp/v1/1234/users/idproviders" $newPath }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}