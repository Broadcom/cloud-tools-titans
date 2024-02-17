{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $ingress := $titanSideCars.ingress }}
  {{- $routes := $ingress.routes }}
  {{- range $routes }}
    {{- $enrich := .enrich }}
    {{- if $enrich }}
      {{- print "$match=" .match }}
      {{- printf "\n" }}
      {{- $calls := list }}
      {{- $actions := $enrich.actions }}
      {{- if $actions }}
        {{- $froms := dict }}
        {{- $tos := dict }}
        {{- range $actions }}
          {{- $_ := set $froms (printf "%s" .from) . }}
          {{- $to := printf "%s" .to }}
          {{- $toStr := printf "%s%s" (ternary "" "header." (contains "." $to)) $to }}
          {{- $_ := set $tos $toStr . }}
        {{- end }}
        {{- $previousActionFrom := "" }}
        {{- $checks := list }}
        {{- $args := dict "inValue" "" "outValue" "test" "expectValue" "test" }}
        {{- range (reverse $actions) }}
          {{- if eq .action "extract" }}
            {{- $toStr := printf "%s%s" (ternary "" "header." (contains "." .to)) .to }}
            {{- if eq $previousActionFrom $toStr }}
              {{- $to := get $tos $toStr | default dict }}
              {{- $_ := set $args "outValue" $args.inValue }}
              {{- template "process_transforms" (dict "transforms" .transforms  "args" $args) -}}
              {{- if $to }}
                {{- if (get $tos $to.from) }}
                {{- else }}
                  {{- $checks = append $checks (dict "header" (printf "%s" .to) "val" $args.outValue) }}
                  {{- $calls = append $calls (dict "from" (printf "%s" .from) "val" $args.inValue "checks" $checks) }}
                {{- end }}
              {{- end }}
            {{- else }}
              {{- $args = dict "inValue" "" "outValue" "test" "expectValue" "test" }}
              {{- $checks = list }}
              {{- template "process_transforms" (dict "transforms" .transforms  "args" $args) -}}
              {{- $checks = append $checks (dict "header" (printf "%s" .to) "val" $args.outValue) }}
              {{- $calls = append $calls (dict "from" (printf "%s" .from) "val" $args.inValue "checks" $checks) }}
              {{- $previousActionFrom = "" }}
            {{- end }}
            {{- $previousActionFrom = .from }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- range $calls }}
        {{- print "$call=" . }}
        {{- printf "\n" }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "process_transforms" -}}
  {{- $transforms := .transforms -}}
  {{- $args := .args -}}
  {{- $outValue := $args.outValue | default "test" }}
  {{- $inValue := $args.inValue | default "" }}
  {{- if $transforms }}
    {{- range (reverse $transforms) }}
      {{- if eq .func "scanf" }}
        {{- $param := first .parameters }}
        {{- $inValue = $param | replace "%_" (randAlpha 5) }}
        {{- $inValue = $inValue | replace "%s" $outValue }}
      {{- else if eq .func "base64_decode" }}
        {{- $inValue = b64enc $inValue }}
      {{- else if eq .func "trim_prefix" }}
        {{- $inValue = printf "%s%s" (first .parameters) $inValue }}
      {{- else if eq .func "split" }}
      {{- end }}
    {{- end }}
  {{- else }}
    {{- $inValue = $outValue }}
  {{- end }}
  {{- $_ := set $args "inValue" $inValue }}
{{- end -}}
