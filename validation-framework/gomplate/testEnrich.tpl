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
        {{- $checks := list }}
        {{- $inout := dict "skipping" dict }}
        {{- range (reverse $actions) }}
          {{- if eq .action "extract" }}
            {{- $skipping := $inout.skipping }}
            {{- if not (hasKey $skipping .from) }}
              {{- $_ := set $inout "skipping" $skipping }}
              {{- $_ := set $inout "inValue" "" }}
              {{- $_ := set $inout "outValue" (randAlpha 5) }}
              {{- $checks = list }}
              {{- template "process_action_recursive" (dict "tos" $tos "action" . "recursive" false "inout" $inout) }}
              {{- $checks = append $checks (dict "header" (printf "%s" $inout.to) "val" $inout.outValue) }}
              {{- $calls = append $calls (dict "from" (printf "%s" $inout.from) "val" $inout.inValue "checks" $checks) }}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- range $calls }}
        {{- print "# $call=" . }}
        {{- printf "\n" }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "process_action_recursive" -}}
  {{- $tos := .tos -}}
  {{- $action := .action }}
  {{- $recursive := .recursive | default false }}
  {{- $inout := .inout -}}
  {{/* {{- printf "# $action=%s\n" $action }}
  {{- printf "# $recursive=%s\n" $recursive }}
  {{- printf "# $inout=%s\n" $inout }} */}}
  {{- if $action }}
    {{- $toStr := $inout.to | default "" }}
    {{- if eq $toStr "" }}
      {{- $toStr = $action.to }}
    {{- end }}
    {{- $to := get $tos $action.from | default dict }}
    {{/* {{- printf "# $to=%s\n\n" $to }} */}}
    {{- $outValue := ternary $inout.inValue $inout.outValue $recursive }}
    {{- $inValue := $inout.outValue }}
    {{- if $to }}
      {{- $args := dict "outValue" $outValue "inValue" $inValue }}
      {{/* {{- printf "\n# before process_transforms=%s\n" $args }} */}}
      {{- template "process_transforms" (dict "transforms" $action.transforms "args" $args) }}
      {{/* {{- printf "# after process_transforms=%s\n\n" $args }} */}}
      {{- if $recursive }}
        {{- $skipping := $inout.skipping | default dict }}
        {{- $_ := set $skipping $action.from true }}
        {{- $_ := set $inout "skipping" $skipping }}
      {{- else }}
        {{- $_ := set $inout "from" $action.from }}
        {{- $_ := set $inout "to" $action.to }}
      {{- end }}
      {{- $_ := set $inout "inValue" $args.inValue }}
      {{- $_ := set $inout "outValue" $args.outValue }}
      {{- template "process_action_recursive" (dict "tos" $tos "action" $to "recursive" true "inout" $inout) }}
    {{- else }}
      {{- $args := dict "outValue" $outValue "inValue" $inValue }}
      {{/* {{- printf "\n# before process_transforms=%s\n" $args }} */}}
      {{- template "process_transforms" (dict "transforms" $action.transforms "args" $args) }}
      {{/* {{- printf "# after process_transforms=%s\n\n" $args }} */}}
      {{- $_ := set $inout "from" $action.from }}
      {{- if $recursive }}
        {{- $skipping := $inout.skipping | default dict }}
        {{- $_ := set $skipping $action.from true }}
        {{- $_ := set $inout "skipping" $skipping }}
      {{- else }}
        {{- $_ := set $inout "to" $action.to }}
        {{- $_ := set $inout "outValue" $args.outValue }}
      {{- end }}
      {{- $_ := set $inout "inValue" $args.inValue }}

    {{- end }}
  {{- end }}
{{- end }}

{{- define "process_transforms" -}}
  {{- $transforms := .transforms -}}
  {{- $args := .args -}}
  {{- $outValue := $args.outValue }}
  {{- $inValue := $args.inValue }}
  {{- if $transforms }}
    {{- range (reverse $transforms) }}
      {{- if eq .func "scanf" }}
        {{- $param := first .parameters }}
        {{- $inValue = $param | replace "%_" (randAlpha 5) }}
        {{- $inValue = $inValue | replace "%s" $outValue }}
      {{- else if eq .func "base64_decode" }}
        {{/* {{- printf "# before base64 [%s]\n" $inValue }} */}}
        {{- $inValue = b64enc $inValue }}
        {{/* {{- printf "# after base64 [%s]\n" $inValue }} */}}
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
