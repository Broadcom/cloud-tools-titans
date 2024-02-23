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
  {{- if $action }}
    {{- $toStr := $inout.to | default "" }}
    {{- if eq $toStr "" }}
      {{- $toStr = $action.to }}
    {{- end }}
    {{- $to := get $tos $action.from | default dict }}
    {{- $outValue := ternary $inout.inValue $inout.outValue $recursive }}
    {{- $inValue := $inout.outValue }}
    {{- if $to }}
      {{- $args := dict "outValue" $outValue "inValue" $inValue }}
      {{- template "process_transforms" (dict "transforms" $action.transforms "args" $args "from" $action.from) }}
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
      {{- template "process_transforms" (dict "transforms" $action.transforms "args" $args "from" $action.from) }}
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
  {{- $from := .from }}
  {{- $args := .args -}}
  {{- $outValue := $args.outValue }}
  {{- $inValue := $outValue }}
  {{- $marker := "xxxxxx" }}
  {{- if $transforms }}
    {{- $values := list }}
    {{- range (reverse $transforms) }}
      {{- if eq .func "scanf" }}
        {{- $param := first .parameters }}
        {{- $param = $param | replace "%_" (ternary $marker (randAlpha 5) (hasPrefix "header.Cookie" $from)) }}
        {{- if and (eq $inValue "") (gt (len $values) 0) }}
          {{- $tmpParts := split "%" $param }}
          {{- $tmpSparts := split "%s" $param }}
          {{- $parts := list }}
          {{- range $k, $v := $tmpParts }}
            {{- $parts = append $parts $v }}
          {{- end }}
          {{- $sparts := list }}
          {{- range $k, $v := $tmpSparts }}
            {{- $sparts = append $sparts $v }}
          {{- end }}
          {{- range $parts }}
            {{- if eq . (first $sparts) }}
              {{- $inValue = printf "%s%s" $inValue . }}
            {{- else if hasPrefix "s" . }}
              {{- $inValue = printf "%s%s%s" $inValue (first $values) (trimPrefix "s" .) }}
              {{- $values = rest $values }}
            {{- end }}
            {{- $sparts = rest $sparts }}
          {{- end }}
        {{- else }}
          {{- $inValue = $param | replace "%s" $inValue }}
        {{- end }}
      {{- else if eq .func "base64_decode" }}
        {{- $inValue = b64enc $inValue }}
      {{- else if eq .func "trim_prefix" }}
        {{- $inValue = printf "%s%s" (first .parameters) $inValue }}
      {{- else if eq .func "split" }}
        {{- $delimiter := index .parameters 0 }}
        {{- $op := index .parameters 1 }}
        {{- $pattern := index .parameters 2 }}
        {{- if hasPrefix "header.Cookie" $from }}
          {{- $inValue = $inValue | replace $marker $pattern }}
        {{- end }}
        {{- if eq $op "index" }}
          {{/* {{- $index := index .parameters 2 }}
          {{- range $i, $e := until $index }}
            {{- $inValue = printf "%s%s" (randAlpha 3) $op }}
          {{- end }} */}}
        {{- else }}
          {{- if eq $op "findFirstPrefix" }}
            {{- $inValue = printf "%s%s%s" (ternary (printf "%s=%s" (randAlpha 3) (randAlpha 3)) (randAlpha 3) (hasPrefix "header.Cookie" $from)) $delimiter (printf "%s" $inValue) }}
          {{- else if eq $op "findFirstContain" }}
            {{- $inValue = printf "%s%s%s" (ternary (printf "%s=%s" (randAlpha 3) (randAlpha 3)) (randAlpha 3) (hasPrefix "header.Cookie" $from)) $delimiter (printf "%s%s%s" (randAlpha 2) $inValue (randAlpha 2)) }}
          {{- else if eq $op "findFirst" }}
            {{- $inValue = printf "%s%s%s" (ternary (printf "%s=%s" (randAlpha 3) (randAlpha 3)) (randAlpha 3) (hasPrefix "header.Cookie" $from)) $delimiter $inValue }}
          {{- end }}
        {{- end }}
      {{- else if eq .func "printf" }}
        {{- $param := first .parameters }}
        {{- $parts := split "\\" $param }}
        {{- range $parts }}
          {{- if hasPrefix "1" . }}
            {{- $tmpVal := randAlpha 5 }}
            {{- $values = append $values $tmpVal }}
            {{- $param = $param | replace "\\1" $tmpVal }}
          {{- else if hasPrefix "2" . }}
            {{- $tmpVal := randAlpha 5 }}
            {{- $values = append $values $tmpVal }}
            {{- $param = $param | replace "\\2" $tmpVal }}
          {{- else if hasPrefix "3" . }}
            {{- $tmpVal := randAlpha 5 }}
            {{- $values = append $values $tmpVal }}
            {{- $param = $param | replace "\\3" $tmpVal }}
          {{- else if hasPrefix "4" . }}
            {{- $tmpVal := randAlpha 5 }}
            {{- $values = append $values $tmpVal }}
            {{- $param = $param | replace "\\4" $tmpVal }}
          {{- else if hasPrefix "5" . }}
            {{- $tmpVal := randAlpha 5 }}
            {{- $values = append $values $tmpVal }}
            {{- $param = $param | replace "\\5" $tmpVal }}
          {{- else if hasPrefix "6" . }}
            {{- $tmpVal := randAlpha 5 }}
            {{- $values = append $values $tmpVal }}
            {{- $param = $param | replace "\\6" $tmpVal }}
          {{- else if hasPrefix "7" . }}
            {{- $tmpVal := randAlpha 5 }}
            {{- $values = append $values $tmpVal }}
            {{- $param = $param | replace "\\7" $tmpVal }}
          {{- else if hasPrefix "8" . }}
            {{- $tmpVal := randAlpha 5 }}
            {{- $values = append $values $tmpVal }}
            {{- $param = $param | replace "\\8" $tmpVal }}
          {{- else if hasPrefix "9" . }}
            {{- $tmpVal := randAlpha 5 }}
            {{- $values = append $values $tmpVal }}
            {{- $param = $param | replace "\\9" $tmpVal }}
          {{- end }}
        {{- end }}
        {{- $outValue = $param }}
        {{- $inValue = "" }}
        {{- $_ := set $args "outValue" $outValue }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- $_ := set $args "inValue" $inValue }}
{{- end -}}
