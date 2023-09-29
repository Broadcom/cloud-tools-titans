
{{- $releaseControl := .releaseControl }}
{{- $canary := $releaseControl.canary | default dict }}
{{- $history := $releaseControl.history | default list }}
{{- $baseLabel := $releaseControl.base | default "" }}
{{- $dependencies := .dependencies }}
{{- range $key, $val := . }}
  {{- if and (ne $key "dependencies") (ne $key "releaseControl") }}
    {{- printf "%s: %s\n" $key $val }}
  {{- end }}
{{- end }}
{{- if $dependencies }}
  {{- printf "dependencies:" }}
  {{- range $dependencies }}
    {{- $name := .name }}
    {{- $respo := .repository }}
    {{- $alias := .alias | default $name }}
    {{- $condition := .condition }}
    {{- $ver := .version }}
    {{- $tags := .tags }}
    {{- $imports := index . "import-values" }}
    {{- if $tags }}
      {{- $releases := ternary (index $canary $name) (list $baseLabel) (hasKey $canary $name) }}
      {{- range $releases }}
        {{- $currentRelease := . }}     
        {{- $label := ternary (printf "-%s" $currentRelease ) $currentRelease (ne $currentRelease "") }}
        {{- printf "\n- name: %s" $name }}
        {{- if ne $name $alias }}
          {{- printf "alias: %s%s" $alias $label | nindent 2 }}
        {{- else }}
          {{- if ne $label "" }}
            {{- printf "alias: %s%s" $alias $label | nindent 2 }}
          {{- end }}
        {{- end }}
        {{- printf "version: %s" $ver | nindent 2 }}
        {{- printf "repository: %s" $respo | nindent 2 }}
        {{- if $condition }}
          {{- printf "condition: %s%s.enabled" $alias $label | nindent 2 }}
        {{- end }}
        {{- if $imports }}
          {{- printf "import-values:" | nindent 2 }}
          {{- range $imports }}
            {{- printf "- child: %s" .child | nindent 4 }}
            {{- printf "parent: global.titanSideCars.envoy.clusters.%s%s" $alias $label | nindent 6 }}
          {{- end }}
        {{- else }}
          {{- printf "import-values:" | nindent 2 }}
          {{- printf "- child: inbound" | nindent 4 }}
          {{- printf "parent: global.titanSideCars.envoy.clusters.%s%s" $alias $label | nindent 6 }}
        {{- end }}
        {{- printf "tags:" | nindent 2}}
        {{- range $tags }}
          {{- printf "- %s" . | nindent 2}}
        {{- end }}
        {{- if ne $label "" }}
          {{- if eq (len $releases) 1 }}
            {{- $foundCurrent := false }}
            {{- range $history }}
              {{- if eq . $currentRelease }}
                {{- $foundCurrent = true }}
              {{- end }}
              {{- if $foundCurrent }}
                {{- printf "- %s" . | nindent 2 }}
              {{- end }}
            {{- end }}
          {{- else }}
            {{- printf "- %s" $currentRelease | nindent 2 }}
          {{- end }}
        {{- end }}     
      {{- end }}
    {{- else }}
      {{- printf "\n" }}
      {{- print (toYaml (list .)) }}
    {{- end }}
  {{- end }}
{{- end }}