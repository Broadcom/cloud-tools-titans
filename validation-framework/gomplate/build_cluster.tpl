{{- $validation := dict "clusters" . }}
{{- $titanSideCars := dict "validation" $validation }}
{{- print (toYaml (dict "titanSideCars" $titanSideCars)) }}